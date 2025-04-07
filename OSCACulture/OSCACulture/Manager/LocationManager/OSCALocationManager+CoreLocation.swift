//
//  OSCALocationManager+CoreLocation.swift
//  OSCACulture
//
//  Created by Stephan Breidenbach on 23.09.22.
//

import Foundation
import CoreLocation

extension CLProximity {
  var toBeaconProximity: OSCALocationManager.Beacon.Proximity {
    switch self {
    case .unknown:
      return OSCALocationManager.Beacon.Proximity.unknown
    case .immediate:
      return OSCALocationManager.Beacon.Proximity.immediate
    case .near:
      return OSCALocationManager.Beacon.Proximity.near
    case .far:
      return OSCALocationManager.Beacon.Proximity.far
    @unknown default:
      return OSCALocationManager.Beacon.Proximity.unknown
    }// end switch case
  }// end var toBeaconProximity
}// end extension enum CLProximity

extension CLBeaconIdentityConstraint {
  convenience init?(from artWald: OSCAArtWald) {
    guard let uuidString = artWald.uUID,
          let uuid  = UUID(uuidString: uuidString),
          let major = artWald.major,
          let minor = artWald.minor else { return nil }
    let clBeaconMajorValue = UInt16(major) as CLBeaconMajorValue
    let clBeaconMinorValue = UInt16(minor) as CLBeaconMinorValue
    self.init(uuid: uuid,
              major: clBeaconMajorValue,
              minor: clBeaconMinorValue)
  }// end init? from art Wald
}// end extension class CLBeaconIdentityConstraint

extension CLCircularRegion {
  convenience init?(from artWald: OSCAArtWald) {
    guard let center = artWald.geopoint?.geoPointStruct.clLocationCoordinate2D,
          let identifier = artWald.objectId
    else { return nil }
    
    self.init(center: center,
              radius: 100.0,
              identifier: identifier)
  }// end init? from art Wald
}// end extension class CLCircularRegion

extension CLLocationCoordinate2D: Equatable {
  public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
    let equalsLat = lhs.latitude == rhs.latitude
    let equalsLon = lhs.longitude == rhs.longitude
    let equals = equalsLat && equalsLon
    return equals
  }// end public static func ==
}// end extension struct CLLocationCoordinate2D

extension CLLocationCoordinate2D: Hashable {
  /// [own hash function](https://www.hackingwithswift.com/example-code/language/how-to-conform-to-the-hashable-protocol)
  public func hash(into hasher: inout Hasher) {
    hasher.combine(latitude)
    hasher.combine(longitude)
  }// end func hash
}// end extension struct CLLocationCoordinate2D

extension Set where Element == CLCircularRegion {
  var circularRegionOfRegions: Element {
    var maxLatitude: Double = -.greatestFiniteMagnitude
    var maxLongitude: Double = -.greatestFiniteMagnitude
    var minLatitude: Double = .greatestFiniteMagnitude
    var minLongitude: Double = .greatestFiniteMagnitude
    forEach{
      maxLatitude = Swift.max(maxLatitude, $0.center.latitude)
      maxLongitude = Swift.max(maxLongitude, $0.center.longitude)
      minLatitude = Swift.min(minLatitude, $0.center.latitude)
      minLongitude = Swift.min(minLongitude, $0.center.longitude)
    }// end for each
    
    let centerLatitude = CLLocationDegrees((maxLatitude + minLatitude) * 0.5)
    let centerLongitude = CLLocationDegrees((maxLongitude + minLongitude) * 0.5)
    let center = CLLocationCoordinate2D(latitude: centerLatitude,
                                        longitude: centerLongitude)
    let centerLocation = CLLocation(latitude: centerLatitude,
                                    longitude: centerLongitude)
    var radius = 0.0
    forEach {
      let location = CLLocation(latitude: $0.center.latitude,
                                longitude: $0.center.longitude)
      let distance = (centerLocation.distance(from: location) + $0.radius)
      if distance > radius { radius = distance }
    }// end for each
    return .init(center: center,
                 radius: radius,
                 identifier: "CircularRegionOfRegions")
  }// end var center
}// end extension Array where Element == CLLocationCoordinate2D
