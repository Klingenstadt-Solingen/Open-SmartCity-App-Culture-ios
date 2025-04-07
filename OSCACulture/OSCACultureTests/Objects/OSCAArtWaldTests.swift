//
//  OSCAArtWaldTests.swift
//  OSCACultureTests
//
//  Created by Stephan Breidenbach on 15.07.22.
//  Reviewed by Stephan Breidenbach on 23.01.23
//

#if canImport(XCTest) && canImport(OSCATestCaseExtension)
import Foundation
import OSCAEssentials
import OSCANetworkService
import XCTest
import OSCATestCaseExtension
@testable import OSCACulture

/// ```console
/// curl -X GET \
///  -H "X-Parse-Application-Id: APPLICATION_ID" \
///  -H "X-Parse-Client-Key: API_CLIENT_KEY" \
///  https://parse-dev.solingen.de/classes/KunstInWald \
///  | python3 -m json.tool
///  | pygmentize -g
///  ```
class OSCAArtWaldTests: OSCAParseClassObjectTestSuite<OSCAArtWald> {
  override open func makeSpecificObject() -> OSCAArtWald? {
    nil
  }// end override open func makeSpecificObject
  
  override func setUpWithError() throws -> Void {
    try super.setUpWithError()
  }// end override func setupWithError
  
  override func tearDownWithError() throws -> Void {
    try super.tearDownWithError()
  }// end override func tearDownWithError
  
  /// Is there a file with the `JSON` scheme example data available?
  /// The file name has to match with the test class name: `OSCAArtWaldTests.json`
  override func testJSONDataAvailable() throws -> Void {
    try super.testJSONDataAvailable()
  }// end override func testJSONDataAvailable
#if DEBUG
  /// Is it possible to deserialize `JSON` scheme example data to an array  `OSCAArtWald` 's?
  override func testDecodingJSONData() throws -> Void {
    try super.testDecodingJSONData()
  }// end override func testDecodingJSONData
#endif
  /// is it possible to fetch up to 1000 `OSCAArtWald` objects in an array from network?
  override func testFetchAllParseObjects() throws -> Void {
    try super.testFetchAllParseObjects()
  }// end override func test testFetchAllParseObjects
  
  override func testFetchParseObjectSchema() throws -> Void {
    try super.testFetchParseObjectSchema()
  }// end override func test testFetchParseObjectSchema
  
  func testSortProximity() throws -> Void {
    var array = makeDummyBeaconArray()
    array = array.sorted(by: { $0.proximity.rawValue < $1.proximity.rawValue })
    XCTAssertTrue(array[0].minor! < array[1].minor!, "0 !< 1")
    XCTAssertTrue(array[1].minor! < array[2].minor!, "1 !< 2")
    XCTAssertTrue(array[2].minor! < array[3].minor!, "2 !< 3")
    XCTAssertTrue(array[3].minor! < array[4].minor!, "3 !< 4")
  }// end testSortProximity
}// end class OSCACoronaChartsTests

extension OSCAArtWaldTests {
  func makeDummyBeaconArray() -> [OSCAArtWald]{
    let array = [OSCAArtWald(minor:2, proximity: .far),
                 OSCAArtWald(minor:3, proximity: .unknown),
                 OSCAArtWald(minor:1, proximity: .near),
                 OSCAArtWald(minor:4, proximity: .unknown),
                 OSCAArtWald(minor:0, proximity: .immediate)]
    return array
  }// end func makeDummyBeaconArray
}// end extension OSCAArtWaldTests
#endif
