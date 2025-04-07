//
//  OSCACultureTests.swift
//  OSCACultureTests
//
//  Created by Stephan Breidenbach on 11.07.22.
//  Reviewed by Stephan Breidenbach on 18.08.22

#if canImport(XCTest) && canImport(OSCATestCaseExtension)
import XCTest
import Combine
import OSCANetworkService
import OSCATestCaseExtension
@testable import OSCACulture

final class OSCACultureTests: XCTestCase {
  static let moduleVersion = "1.0.5"
  var cancellables        : Set<AnyCancellable>!
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    self.cancellables = []
  }// end override func setupWithError
  
  func testModuleInit() throws -> Void {
    // init module
    let module = try makeDevModule()
    XCTAssertNotNil(module)
    XCTAssertEqual(module.bundlePrefix, "de.osca.culture")
    XCTAssertEqual(module.version, OSCACultureTests.moduleVersion)
    // init bundle
    let bundle = OSCACulture.bundle
    XCTAssertNotNil(bundle)
    XCTAssertNotNil(self.devPlistDict)
    XCTAssertNotNil(self.productionPlistDict)
  }// end func testModuleInit
  
  func testFetchAllArtWald() throws -> Void {
    var arts: [OSCAArtWald] = []
    var error: Error?
    let maxCount: Int = 20
    
    let expectation = self.expectation(description: "fetchAllArtWalds")
    let module = try makeDevModule()
    XCTAssertNotNil(module)
    module.fetchAllArtWald(maxCount: maxCount)
      .sink { completion in
        switch completion {
        case .finished:
          expectation.fulfill()
        case let .failure(encounteredError):
          error = encounteredError
          expectation.fulfill()
        }// end switch completion
      } receiveValue: { allArtWaldFromNetwork in
        arts = allArtWaldFromNetwork
      }// end sink
      .store(in: &self.cancellables)
    waitForExpectations(timeout: 10)
    
    XCTAssertNil(error)
    XCTAssertTrue(!arts.isEmpty)
  }// end func testFetchAllArtWald
}// end final class OSCACultureTests

// MARK: - factory methods
extension OSCACultureTests {
  public func makeDevModuleDependencies() throws -> OSCACulture.Dependencies {
    let networkService = try makeDevNetworkService()
    let userDefaults   = try makeUserDefaults(domainString: "de.osca.culture")
    let dependencies = OSCACulture.Dependencies(
      networkService: networkService,
      userDefaults: userDefaults)
    return dependencies
  }// end public func makeDevModuleDependencies
  
  public func makeDevModule() throws -> OSCACulture {
    let devDependencies = try makeDevModuleDependencies()
    // initialize module
    let module = OSCACulture.create(with: devDependencies)
    return module
  }// end public func makeDevModule
  
  public func makeProductionModuleDependencies() throws -> OSCACulture.Dependencies {
    let networkService = try makeProductionNetworkService()
    let userDefaults   = try makeUserDefaults(domainString: "de.osca.culture")
    let dependencies = OSCACulture.Dependencies(
      networkService: networkService,
      userDefaults: userDefaults)
    return dependencies
  }// end public func makeProductionModuleDependencies
  
  public func makeProductionModule() throws -> OSCACulture {
    let productionDependencies = try makeProductionModuleDependencies()
    // initialize module
    let module = OSCACulture.create(with: productionDependencies)
    return module
  }// end public func makeProductionModule
}// end extension final class OSCACultureTests
#endif
