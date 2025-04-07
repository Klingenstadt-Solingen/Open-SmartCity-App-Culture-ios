//
//  OSCALocationManager+Beacon.swift
//  OSCACulture
//
//  Created by Stephan Breidenbach on 23.09.22.
//

import Foundation
import CoreLocation

// MARK: - Beacon definition
extension OSCALocationManager {
  struct Beacon {
    /// Beacon's UUID string
    let uuid: String
    /// Beacon's signal strength in Db
    var rssi: Int
    /// Beacon's major
    let major: Int
    /// Beacon's minor
    let minor: Int
    /// Beacon's accuracy in Meters ( <0 => unknown )
    var accuracy: Double
    /// Becons's proximity
    var proximity: OSCALocationManager.Beacon.Proximity
    /// Beacon's timestamp
    var timestamp: Date
    /// for debug output
    var debugDescription: String { "UUID:\(uuid), major:\(major), minor:\(minor), proximity: \(proximity)" }
  }// end struct Beacon
}// end extension struct OSCALocationManager

extension OSCALocationManager.Beacon {
  enum Proximity: Int {
    case immediate = 0
    case near = 1
    case far = 2
    case unknown = 99
  }// end enum Proximity
}// end extension enum Beacon

extension OSCALocationManager.Beacon.Proximity {
  var toOSCAWaldProximity: OSCAArtWald.Proximity {
    switch self {
    case .immediate:
      return OSCAArtWald.Proximity.immediate
    case .near:
      return OSCAArtWald.Proximity.near
    case .far:
      return OSCAArtWald.Proximity.far
    case .unknown:
      return OSCAArtWald.Proximity.unknown
    }// end switch case
  }// end var toOSCAWaldProximity
}// end extension enum Proximity

extension OSCALocationManager.Beacon: Equatable {
  static func ==(lhs: OSCALocationManager.Beacon, rhs: OSCALocationManager.Beacon) -> Bool {
    let uuidEqals = lhs.uuid == rhs.uuid
    let majorEquals = lhs.major == rhs.major
    let minorEquals = lhs.minor == rhs.minor
    let beaconEquals = uuidEqals &&
    majorEquals &&
    minorEquals
    return beaconEquals
  }// end stati func ==
}// end extension struct Beacon

extension OSCALocationManager.Beacon: Hashable {
  /// [own hash function](https://www.hackingwithswift.com/example-code/language/how-to-conform-to-the-hashable-protocol)
  func hash(into hasher: inout Hasher) {
    hasher.combine(uuid)
    hasher.combine(major)
    hasher.combine(minor)
  }// end func hash
}// end extension public class Beacon
extension OSCALocationManager.Beacon {
  init(from clBeacon: CLBeacon) {
    self.uuid = clBeacon.uuid.uuidString
    self.rssi = clBeacon.rssi
    self.major = clBeacon.major.intValue
    self.minor = clBeacon.minor.intValue
    self.accuracy = clBeacon.accuracy
    self.timestamp = clBeacon.timestamp
    self.proximity = clBeacon.proximity.toBeaconProximity
  }// end private init
}// end extension public class Beacon
