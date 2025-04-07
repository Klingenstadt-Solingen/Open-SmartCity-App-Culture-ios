//
//  CoreLocationTests.swift
//  OSCACultureTests
//
//  Created by Stephan Breidenbach on 26.09.22.
//

#if canImport(XCTest) && canImport(OSCATestCaseExtension)
import Foundation
import OSCAEssentials
import OSCANetworkService
import XCTest
import OSCATestCaseExtension
import CoreLocation
@testable import OSCACulture

/// ```console
/// curl -X GET \
///  -H "X-Parse-Application-Id: APPLICATION_ID" \
///  -H "X-Parse-Client-Key: API_CLIENT_KEY" \
///  https://parse-dev.solingen.de/classes/KunstInWald \
///  | python3 -m json.tool
///  | pygmentize -g
///  ```
class CoreLocationTests: XCTestCase {
  
  override func setUpWithError() throws {
    try super.setUpWithError()
  }// end override func setUpWithError
  
  override func tearDownWithError() throws {
    try super.tearDownWithError()
  }// end override func tearDownWithError
  
  func testCircularRegionOfRegions() throws {
    XCTAssertNoThrow(try contains() ,"")
  }// end func testCircularRegionOfRegions

}// end class OSCACoronaChartsTests

extension CoreLocationTests {
  enum Error: Swift.Error {
    case notInRegion(CLLocationCoordinate2D)
  }// end enum Error
  
  public func contains() throws -> Void {
    let set = makeGeoRangesSet()
    let circularRegionOfRegions = set.circularRegionOfRegions
    do {
      try set.forEach {
        if !circularRegionOfRegions
          .contains($0.center) { throw CoreLocationTests.Error.notInRegion($0.center) }
      }// end try for each
    } catch let CoreLocationTests.Error.notInRegion(clLocationCoordinate2D){
        throw CoreLocationTests.Error.notInRegion(clLocationCoordinate2D)
    }// end do catch
  }// end public func contains
  
  public func makeOSCAWaldBeacons() -> [OSCAArtWald] {
    let array: [OSCAArtWald] = [
      OSCAArtWald(objectId: "lpKuXWHCiB", geopoint: ParseGeoPoint(latitude: 51.162313, longitude: 7.077793),minor: 0),
      OSCAArtWald(objectId: "nBggjeYVTP", geopoint: ParseGeoPoint(latitude: 51.162349, longitude: 7.077837),minor: 1),
      OSCAArtWald(objectId: "0tGPP61CQi", geopoint: ParseGeoPoint(latitude: 51.162387, longitude: 7.077891),minor: 2),
      OSCAArtWald(objectId: "V3mEVR9YNp", geopoint: ParseGeoPoint(latitude: 51.162424, longitude: 7.077939),minor: 3),
      OSCAArtWald(objectId: "zzxgYy8JsG", geopoint: ParseGeoPoint(latitude: 51.162459, longitude: 7.077969),minor: 4),
      OSCAArtWald(objectId: "mJPh6QgTbA", geopoint: ParseGeoPoint(latitude: 51.162492, longitude: 7.078010),minor: 5),
      OSCAArtWald(objectId: "ioo667EhD1", geopoint: ParseGeoPoint(latitude: 51.162511, longitude: 7.078083),minor: 6),
      OSCAArtWald(objectId: "TIsVpBVnrH", geopoint: ParseGeoPoint(latitude: 51.162640, longitude: 7.078034),minor: 7),
      OSCAArtWald(objectId: "S66tOAwWRA", geopoint: ParseGeoPoint(latitude: 51.162732, longitude: 7.078163),minor: 8),
      OSCAArtWald(objectId: "WHkcKDKF5Z", geopoint: ParseGeoPoint(latitude: 51.162755, longitude: 7.078363),minor: 9),
      OSCAArtWald(objectId: "N1vce35D2m", geopoint: ParseGeoPoint(latitude: 51.162632, longitude: 7.078745),minor: 10),
      OSCAArtWald(objectId: "zZNZPawUJ0", geopoint: ParseGeoPoint(latitude: 51.162862, longitude: 7.079012),minor: 11),
      OSCAArtWald(objectId: "jzeYChXINA", geopoint: ParseGeoPoint(latitude: 51.162367, longitude: 7.078514),minor: 12),
      OSCAArtWald(objectId: "f727iwZSAV", geopoint: ParseGeoPoint(latitude: 51.161908, longitude: 7.077217),minor: 13),
      OSCAArtWald(objectId: "pOcSoCfioQ", geopoint: ParseGeoPoint(latitude: 51.162526, longitude: 7.076961),minor: 14),
      OSCAArtWald(objectId: "3vi3SSEWS9", geopoint: ParseGeoPoint(latitude: 51.162793, longitude: 7.076739),minor: 15)
    ]
    return array
  }// end func makeOSCAWaldBeacons
  
  public func makeGeoRanges() -> [CLCircularRegion]{
    let geoRanges = makeOSCAWaldBeacons()
      .compactMap { CLCircularRegion(from: $0) }
    return geoRanges
  }// end public func makeGeoRanges
  
  public func makeGeoRangesSet() -> Set<CLCircularRegion> {
    let set = Set(makeGeoRanges()
      .map { $0 } )
    return set
  }// end func makeGeoRangesSet
  
}// end extension OSCAArtWaldTests
#endif
