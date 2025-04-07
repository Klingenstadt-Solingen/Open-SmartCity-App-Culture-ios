//
//  OSCALocationManager+OSCAArtWald.swift
//  OSCACulture
//
//  Created by Stephan Breidenbach on 23.09.22.
//

import Foundation

extension OSCAArtWald {
  init(with beacon: OSCALocationManager.Beacon) {
    uUID = beacon.uuid
    major = beacon.major
    minor = beacon.minor
    proximity = beacon.proximity.toOSCAWaldProximity
  }// end convenience init with beacon
}// end extension struct OSCAArtWald
