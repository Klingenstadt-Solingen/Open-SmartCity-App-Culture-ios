//
//  OSCALocationManager.swift
//  OSCACulture
//
//  Created by Stephan Breidenbach on 22.09.22.
//

import Foundation
import CoreLocation
import Combine
import OSCAEssentials

public typealias OSCALocationStatePublisher = AnyPublisher<OSCALocationState,Never>

public enum OSCALocationState {
  case initializing
  case noPermission
  case updatingLocation
  case outOfGeoRange(center: OSCAGeoPoint)
  case inGeoRange(center: OSCAGeoPoint)
  case didRangeBeacon
}// end enum OSCALocationState

extension OSCALocationState: Equatable {}

/// let uuid = UUID(uuidString: "529b0f66-ac4c-4e73-8cf4-8b2f91040c24")!
/// let beaconIdentityConstraint = CLBeaconIdentityConstraint(uuid: uuid,
///                                            major: 845,
///                                            minor: 7)
/// [based upon](https://www.hackingwithswift.com/example-code/location/how-to-detect-ibeacons)
final class OSCALocationManager: NSObject {
  private let cleanUpSeconds = 15
  private var locationManager: CLLocationManager
  private var beaconIdentityConstraints: Set<CLBeaconIdentityConstraint>
  private var beaconLocationRegions: Set<CLCircularRegion>
  var bindings = Set<AnyCancellable>()
  
  @Published private var beacons: Set<OSCALocationManager.Beacon> = Set<OSCALocationManager.Beacon>()
  @Published private var state: OSCALocationState = .initializing
  @Published private var location: CLLocation?

  init?(with artWaldItems: [OSCAArtWald]) {
    let beaconIdentityConstraints = artWaldItems.compactMap{ CLBeaconIdentityConstraint(from: $0) }
    let beaconLocationRegions = artWaldItems.compactMap { CLCircularRegion(from: $0) }
    let beaconIdentityConstraintsSet = Set(beaconIdentityConstraints.map{ $0 })
    let beaconLocationRegionsSet = Set(beaconLocationRegions.map{ $0 })
    guard !beaconIdentityConstraints.isEmpty
    else { return nil }
    self.beaconIdentityConstraints = beaconIdentityConstraintsSet
    self.beaconLocationRegions = beaconLocationRegionsSet
    self.locationManager = CLLocationManager()
    super.init()
    setupLocationManager()
  }// end
  
  deinit {
#if DEBUG
    print("\(String(describing: self)): \(#function)")
#endif
    if !bindings.isEmpty {
      for sub in bindings {
        bindings.remove(sub)
        sub.cancel()
      }// end for sub in bindings
    }// end if
    locationManager.stopUpdatingLocation()
    stopScanning()
  }// end deinit
  
  ///[monitor geographic region](https://developer.apple.com/documentation/corelocation/monitoring_the_user_s_proximity_to_geographic_regions)
  private func setupGeoRange(for region: CLCircularRegion) {
    region.notifyOnEntry = true
    region.notifyOnExit = true
    locationManager.startMonitoring(for: region)
  }// end private func setupGeoRang
  
  private func startScanning() {
    for beaconIdentityConstraint in beaconIdentityConstraints {
      locationManager.startRangingBeacons(satisfying: beaconIdentityConstraint)
    }// end for each
  }// end private func startScanning
  
  private func stopScanning() {
    if !beaconIdentityConstraints.isEmpty {
      for constraint in beaconIdentityConstraints {
        beaconIdentityConstraints.remove(constraint)
        locationManager.stopRangingBeacons(satisfying: constraint)
      }// end for each
    }// end if
  }// end private func stopScanning
  
  /// - Parameter beacons: `call by reference` `Set` of `Beacon`s
  /// - Parameter after timeout: timeout in Seconds
  private func cleanup( beacons: inout Set<OSCALocationManager.Beacon>, after timeout: Int) -> Void {
    guard !beacons.isEmpty else { return }
    let now: Date = Date()
    let timeInterval: TimeInterval = TimeInterval(timeout)
    var localBeacons = beacons
    for beacon in localBeacons {
      let timeStampAdded = beacon.timestamp.addingTimeInterval(timeInterval)
      if timeStampAdded < now {
        localBeacons.remove(beacon)
      }// end if
    }// for each
    beacons = localBeacons
  }// end private func cleanup after timeout in Seconds
  
  private func found(beacon: OSCALocationManager.Beacon) -> Void {
    if !beacons.isEmpty {
      beacons.remove(beacon)
      beacons.insert(beacon)
      cleanup(beacons: &beacons, after: cleanUpSeconds)
    } else {
      beacons.insert(beacon)
    }// end if
  }// end private func found beacon
}// end public class OSCALocationManager

// MARK: - CLLocationManagerDelegate conformance
extension OSCALocationManager: CLLocationManagerDelegate {
  func setupLocationManager() {
    locationManager.delegate = self
    locationManager.requestAlwaysAuthorization()
  }// end func setupLocationManager
  
  func locationManager(_ manager: CLLocationManager,
                       didChangeAuthorization status: CLAuthorizationStatus) -> Void {
    guard manager.delegate === self else { return }
    switch status {
    case .authorizedAlways:
      if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
        if CLLocationManager.isRangingAvailable() {
          locationManager.startUpdatingLocation()
        }// end if
      }// end if
    case .denied, .restricted:
      state = .noPermission
    case .notDetermined, .authorizedWhenInUse:
      locationManager.requestAlwaysAuthorization()
    @unknown default:
      state = .noPermission
    }// end switch case
  }// end func locationManager did change authorization status
  
  func locationManager(_ manager: CLLocationManager,
                       didUpdateLocations locations: [CLLocation]) {
    guard manager.delegate === self,
          !locations.isEmpty,
          let location = locations.first else { return }
    switch state {
    case .initializing:
      let region = beaconLocationRegions.circularRegionOfRegions
      setupGeoRange(for: region)
      state = .updatingLocation
    case .inGeoRange,
         .outOfGeoRange,
         .didRangeBeacon,
         .updatingLocation,
         .noPermission:
      break
    }// end switch case
    self.location = location
  }// end func location manager did update locations
  
  func locationManager(_ manager: CLLocationManager,
                       didDetermineState state: CLRegionState,
                       for region: CLRegion) {
    guard manager.delegate === self,
          region.identifier == "CircularRegionOfRegions",
          let circularRegion = region as? CLCircularRegion,
          self.state == .updatingLocation
    else { return }
    switch state {
    case .inside:
      startScanning()
      self.state = .inGeoRange(center: OSCAGeoPoint(circularRegion.center))
    case .outside:
      stopScanning()
      self.state = .outOfGeoRange(center: OSCAGeoPoint(circularRegion.center))
    case .unknown:
      stopScanning()
      self.state = .outOfGeoRange(center: OSCAGeoPoint(circularRegion.center))
    }// end switch state
  }// end func location manager did determine state for region
  
  func locationManager(_ manager: CLLocationManager,
                       didEnterRegion region: CLRegion) -> Void {
    guard manager.delegate === self,
          region.identifier == "CircularRegionOfRegions",
          let circularRegion = region as? CLCircularRegion
    else { return }
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    startScanning()
    state = .inGeoRange(center: OSCAGeoPoint(circularRegion.center))
  }// end func location manager did enter region
  
  func locationManager(_ manager: CLLocationManager,
                       didExitRegion region: CLRegion) {
    guard manager.delegate === self,
          region.identifier == "CircularRegionOfRegions",
          let circularRegion = region as? CLCircularRegion
    else { return }
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
    stopScanning()
    state = .outOfGeoRange(center: OSCAGeoPoint(circularRegion.center))
  }// end func location manager did exit region
  
  func locationManager(_ manager: CLLocationManager,
                       didRange beacons: [CLBeacon],
                       satisfying beaconConstraint: CLBeaconIdentityConstraint) -> Void {
    guard manager.delegate === self,
          beaconIdentityConstraints.contains(beaconConstraint),
          !beacons.isEmpty,
          let clBeacon = beacons.first
    else { return }
    let proximity = clBeacon.proximity
    var beacon: OSCALocationManager.Beacon?
    switch proximity {
    case .far:
#if DEBUG
      print("proximity: far")
#endif
      //beacon = Beacon(from: clBeacon)
    case .unknown:
#if DEBUG
      print("proximity: unknown")
#endif
    case .near:
#if DEBUG
      print("proximity: near")
#endif
      beacon = Beacon(from: clBeacon)
    case .immediate:
#if DEBUG
      print("proximity: immediate")
#endif
      beacon = Beacon(from: clBeacon)
    @unknown default:
#if DEBUG
      print("proximity: unknown default")
#endif
    }// end switch case
    if let beacon = beacon {
      found(beacon: beacon)
      state = .didRangeBeacon
    }// end if
  }// end func locationManager did range beacons satisfying beacon constraint
}// end extension public final class OSCALocationManager

// MARK: - public interface
extension OSCALocationManager {
  
  public enum Error {
    case timeout
  }// end
  
  public func getState() -> OSCALocationStatePublisher {
    let publisher: OSCALocationStatePublisher =
      $state
        .dropFirst()
        .subscribe(on: OSCAScheduler.backgroundWorkScheduler)
        .eraseToAnyPublisher()
    return publisher
  }// end public func getState
  
  public typealias BeaconPublisher = AnyPublisher<Set<OSCALocationManager.Beacon>, OSCALocationManager.Error>
  
  public func fetchBeacons() -> OSCALocationManager.BeaconPublisher {
    let publisher: OSCALocationManager.BeaconPublisher =
    $beacons
      .subscribe(on: OSCAScheduler.backgroundWorkScheduler)
      .setFailureType(to: OSCALocationManager.Error.self)
    /*
     .timeout(40, scheduler: DispatchQueue.main) {[weak self] in
     guard let `self` = self else { return OSCALocationManager.Error.timeout }
     self.stopScanning()
     return OSCALocationManager.Error.timeout }
     */
      .eraseToAnyPublisher()
    return publisher
  }// end public func fetchBeacon
}// end extension final class OSCALocationManager

extension OSCALocationManager.Error: Swift.Error {}
extension OSCALocationManager.Error: Equatable {}
