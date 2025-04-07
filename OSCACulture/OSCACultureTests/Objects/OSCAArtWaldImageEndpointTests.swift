//
//  OSCAArtWaldImageEndpointTests.swift
//  OSCACultureTests
//
//  Created by Stephan Breidenbach on 23.02.24.
//

#if canImport(XCTest) && canImport(OSCATestCaseExtension)
import Foundation
import OSCAEssentials
import OSCANetworkService
import XCTest
import OSCATestCaseExtension
@testable import OSCACulture

final class OSCAArtWaldImageEndpointTests: XCTestCase {
  let moduleTests: OSCACultureTests = OSCACultureTests()
  let imageDataCache = NSCache<NSString, NSData>()
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    try self.moduleTests.setUpWithError()
    try initCache()
    try initThumbCache()
  }// end override func setupWithError
  
  override func tearDownWithError() throws {
    imageDataCache.removeAllObjects()
    try self.moduleTests.tearDownWithError()
    try super.tearDownWithError()
  }// end override func tearDownWithError
  
  func testFetchAllImageURLs() throws {
    self.endpointURLs.forEach {
      guard let url = $0 else { XCTFail(); return }
      XCTAssertNotNil(self.get(for: url), url.absoluteString)
    }// end for each
  }// end test Fetch all image urls
  
  func testFetchGDIImageThumbURLs() throws {
    self.endpointThumbGDIURLs.forEach {
      guard let url = $0 else { XCTFail(); return }
      XCTAssertNotNil(self.get(for: url), url.absoluteString)
    }// end for each
  }// end func test fetch gdi image thumb urls
  
  func testFetchAllImageThumbURLs() throws {
    self.endpointThumbURLs.forEach {
      guard let url = $0 else { XCTFail(); return }
      XCTAssertNotNil(self.get(for: url), url.absoluteString)
    }// end for each
  }// end test fetch all image thumb urls
  
}// end final class OSCAArtWaldImageEndpointTests

extension OSCAArtWaldImageEndpointTests {
  var endpointsGDIThumbs: [String] {[
"01_titel_WALD_markiert",
"01_WALD_markiert_01",
"01_WALD_markiert_02",
"01_WALD_markiert_03",
"01_WALD_markiert_04",
"01_WALD_markiert_05",
"01_WALD_markiert_06",
"01_WALD_markiert_07",
"01_WALD_markiert_08",
"01_WALD_markiert_09",
"01_WALD_markiert_10",
"01_WALD_markiert_11",
"01_WALD_markiert_12",
"01_WALD_markiert_13",
"01_WALD_markiert_14",
"01_WALD_markiert_15",
"01_WALD_markiert_16",
"01_WALD_markiert_17",
"01_WALD_markiert_18",
"01_WALD_markiert_19",
"01_WALD_markiert_20",
"02_titel_WALDflaechen_01",
"02_WALDflaechen_02",
"02_WALDflaechen_03",
"02_WALDflaechen_04",
"02_WALDflaechen_05",
"02_WALDflaechen_06",
"02_WALDflaechen_07",
"02_WALDflaechen_08",
"02_WALDflaechen_09",
"02_WALDflaechen_10",
"03_titel_WALDgestalten",
"03_WALDgestalten_01",
"03_WALDgestalten_02",
"03_WALDgestalten_03",
"03_WALDgestalten_04",
"03_WALDgestalten_05",
"03_WALDgestalten_06",
"03_WALDgestalten_07",
"03_WALDgestalten_08",
"03_WALDgestalten_09",
"03_WALDgestalten_10",
"03_WALDgestalten_11",
"03_WALDgestalten_12",
"03_WALDgestalten_13",
"03_WALDgestalten_14",
"03_WALDgestalten_15",
"03_WALDgestalten_16",
"04_titel_WALDER_Stolpersteine",
"04_WALDER_Stolpersteine_01",
"04_WALDER_Stolpersteine_02",
"04_WALDER_Stolpersteine_03",
"04_WALDER_Stolpersteine_04",
"04_WALDER_Stolpersteine_05",
"04_WALDER_Stolpersteine_06",
"04_WALDER_Stolpersteine_07",
"04_WALDER_Stolpersteine_08",
"04_WALDER_Stolpersteine_09",
"04_WALDER_Stolpersteine_10",
"04_WALDER_Stolpersteine_11",
"04_WALDER_Stolpersteine_12",
"05_titel_zaungeschichten_03",
"05_zaungeschichten_01",
"05_zaungeschichten_02",
"05_zaungeschichten_03",
"05_zaungeschichten_04",
"05_zaungeschichten_05",
"05_zaungeschichten_06",
"05_zaungeschichten_07",
"06_titel_WALDER_Lichtblicke",
"06_WALDER_Lichtblicke_01",
"06_WALDER_Lichtblicke_02",
"06_WALDER_Lichtblicke_03",
"06_WALDER_Lichtblicke_04",
"06_WALDER_Lichtblicke_05",
"06_WALDER_Lichtblicke_06",
"06_WALDER_Lichtblicke_07",
"06_WALDER_Lichtblicke_08",
"06_WALDER_Lichtblicke_09",
"07_titel_Tapis_de_BOIS",
"08_titel_WALDER_Laeden",
"08_WALDER_Laeden_01",
"08_WALDER_Laeden_02",
"08_WALDER_Laeden_03",
"08_WALDER_Laeden_04",
"09_Durch_WALD_und_Zeit_01",
"09_Durch_WALD_und_Zeit_02",
"09_Durch_WALD_und_Zeit_03",
"09_Durch_WALD_und_Zeit_04",
"09_titel_Durch_WALD_und_Zeit",
"10_titel_WALDER_Jugendstil_web",
"10_WALDER_Jugendstil_01",
"10_WALDER_Jugendstil_02",
"10_WALDER_Jugendstil_03",
"10_WALDER_Jugendstil_04",
"10_WALDER_Jugendstil_05",
"10_WALDER_Jugendstil_06",
"10_WALDER_Jugendstil_07",
"10_WALDER_Jugendstil_08",
"BIKO_Heiderose_Birkenstock_Kotalla",
"Ela_Schneider",
"Juergen_Schmatz",
"Manuela_Stein",
"Michael_Bauer_Brandes",
"Michael_Klette",
"Sabine_Smith",
"Susanne_Mueller_Koelmel",
"Ulle_Huth"
  ]}
}

extension OSCAArtWaldImageEndpointTests {
  var imageURLString: String { "https://geoportal.solingen.de/buergerservice1/ressourcen/kunstinwald/" }
  var imageThumbURLString: String { "https://geoportal.solingen.de/buergerservice1/ressourcen/kunstinwald/thumbs/"
}
  var mimeTypeString: String { ".jpg" }
  var endpoints: [String] { [
    "BIKO_Heiderose_Birkenstock_Kotalla",
    "Ela_Schneider",
    "Juergen_Schmatz",
    "Manuela_Stein",
    "Michael_Bauer_Brandes",
    "Michael_Klette",
    "Sabine_Smith",
    "Susanne_Mueller_Koelmel",
    "Ulle_Huth",
    "01_WALD_markiert_01",
    "01_WALD_markiert_02",
    "01_WALD_markiert_03",
    "01_WALD_markiert_04",
    "01_WALD_markiert_05",
    "01_WALD_markiert_06",
    "01_WALD_markiert_07",
    "01_WALD_markiert_08",
    "01_WALD_markiert_09",
    "01_WALD_markiert_10",
    "01_WALD_markiert_11",
    "01_WALD_markiert_12",
    "01_WALD_markiert_13",
    "01_WALD_markiert_14",
    "01_WALD_markiert_15",
    "01_WALD_markiert_16",
    "01_WALD_markiert_17",
    "01_WALD_markiert_18",
    "01_WALD_markiert_19",
    "01_WALD_markiert_20",
    "02_WALDflaechen_02",
    "02_WALDflaechen_03",
    "02_WALDflaechen_04",
    "02_WALDflaechen_05",
    "02_WALDflaechen_06",
    "02_WALDflaechen_07",
    "02_WALDflaechen_08",
    "02_WALDflaechen_09",
    "02_WALDflaechen_10",
    "03_WALDgestalten_01",
    "03_WALDgestalten_02",
    "03_WALDgestalten_03",
    "03_WALDgestalten_04",
    "03_WALDgestalten_05",
    "03_WALDgestalten_06",
    "03_WALDgestalten_07",
    "03_WALDgestalten_08",
    "03_WALDgestalten_09",
    "03_WALDgestalten_10",
    "03_WALDgestalten_11",
    "03_WALDgestalten_12",
    "03_WALDgestalten_13",
    "03_WALDgestalten_14",
    "03_WALDgestalten_15",
    "03_WALDgestalten_16",
    "04_WALDER_Stolpersteine_01",
    "04_WALDER_Stolpersteine_02",
    "04_WALDER_Stolpersteine_03",
    "04_WALDER_Stolpersteine_04",
    "04_WALDER_Stolpersteine_05",
    "04_WALDER_Stolpersteine_06",
    "04_WALDER_Stolpersteine_07",
    "04_WALDER_Stolpersteine_08",
    "04_WALDER_Stolpersteine_09",
    "04_WALDER_Stolpersteine_10",
    "04_WALDER_Stolpersteine_11",
    "04_WALDER_Stolpersteine_12",
    "05_zaungeschichten_01",
    "05_zaungeschichten_02",
    "05_zaungeschichten_03",
    "05_zaungeschichten_04",
    "05_zaungeschichten_05",
    "05_zaungeschichten_06",
    "05_zaungeschichten_07",
    "06_WALDER_Lichtblicke_01",
    "06_WALDER_Lichtblicke_02",
    "06_WALDER_Lichtblicke_03",
    "06_WALDER_Lichtblicke_04",
    "06_WALDER_Lichtblicke_05",
    "06_WALDER_Lichtblicke_06",
    "06_WALDER_Lichtblicke_07",
    "06_WALDER_Lichtblicke_08",
    "06_WALDER_Lichtblicke_09",
    "08_WALDER_Laeden_01",
    "08_WALDER_Laeden_02",
    "08_WALDER_Laeden_03",
    "08_WALDER_Laeden_04",
    "09_Durch_WALD_und_Zeit_01",
    "09_Durch_WALD_und_Zeit_02",
    "09_Durch_WALD_und_Zeit_03",
    "09_Durch_WALD_und_Zeit_04",
    "10_WALDER_Jugendstil_01",
    "10_WALDER_Jugendstil_02",
    "10_WALDER_Jugendstil_03",
    "10_WALDER_Jugendstil_04",
    "10_WALDER_Jugendstil_05",
    "10_WALDER_Jugendstil_06",
    "10_WALDER_Jugendstil_07",
    "10_WALDER_Jugendstil_08",
    "11_Kirche_in_WALD_Serie_1_01",
    "11_Kirche_in_WALD_Serie_1_02",
    "11_Kirche_in_WALD_Serie_1_03",
    "11_Kirche_in_WALD_Serie_1_04",
    "11_Kirche_in_WALD_Serie_1_05",
    "11_Kirche_in_WALD_Serie_1_06",
    "11_Kirche_in_WALD_Serie_1_07",
    "11_Kirche_in_WALD_Serie_1_08",
    "11_Kirche_in_WALD_Serie_1_09",
    "11_Kirche_in_WALD_Serie_2_01",
    "11_Kirche_in_WALD_Serie_2_02",
    "11_Kirche_in_WALD_Serie_2_03",
    "11_Kirche_in_WALD_Serie_2_04",
    "11_Kirche_in_WALD_Serie_2_05",
    "11_Kirche_in_WALD_Serie_2_06",
    "11_Kirche_in_WALD_Serie_3_01",
    "11_Kirche_in_WALD_Serie_3_02",
    "11_Kirche_in_WALD_Serie_3_03",
    "11_Kirche_in_WALD_Serie_3_04",
    "11_Kirche_in_WALD_Serie_3_05",
    "11_Kirche_in_WALD_Serie_3_06",
    "11_Kirche_in_WALD_Serie_3_07",
    "11_Kirche_in_WALD_Serie_3_08",
    "11_Kirche_in_WALD_Serie_3_09",
    "11_Kirche_in_WALD_Serie_3_10",
    "11_Kirche_in_WALD_Serie_3_11",
    "11_Kirche_in_WALD_Serie_3_12",
    "11_Kirche_in_WALD_Serie_3_13",
    "11_Kirche_in_WALD_Serie_3_14",
    "11_Kirche_in_WALD_Serie_3_15",
    "11_Kirche_in_WALD_Serie_3_16",
    "11_Kirche_in_WALD_Serie_3_17",
    "11_Kirche_in_WALD_Serie_3_18",
    "11_Kirche_in_WALD_Serie_3_19",
    "11_Kirche_in_WALD_Serie_3_20",
    "11_Kirche_in_WALD_Serie_3_21",
    "11_Kirche_in_WALD_Serie_3_22",
    "11_Kirche_in_WALD_Serie_3_23",
    "11_Kirche_in_WALD_Serie_3_24",
    "11_Kirche_in_WALD_Serie_3_25",
    "11_Kirche_in_WALD_Serie_3_26",
    "11_Kirche_in_WALD_Serie_3_27",
    "11_Kirche_in_WALD_Serie_3_28",
    //"11_Kirche_in_WALD_Video",
    "12_SpiegelWALD_01",
    "12_SpiegelWALD_02",
    "12_SpiegelWALD_03",
    "12_SpiegelWALD_04",
    "12_SpiegelWALD_05",
    "12_SpiegelWALD_06",
    "12_SpiegelWALD_07",
    "12_SpiegelWALD_08",
    "13_WALD_und_Flur_01",
    "13_WALD_und_Flur_02",
    "13_WALD_und_Flur_03",
    "13_WALD_und_Flur_04",
    "13_WALD_und_Flur_05",
    "13_WALD_und_Flur_06",
    "13_WALD_und_Flur_07",
    "13_WALD_und_Flur_08",
    "13_WALD_und_Flur_09",
    "13_WALD_und_Flur_10",
    "13_WALD_und_Flur_11",
    "13_WALD_und_Flur_12",
    "13_WALD_und_Flur_13",
    "13_WALD_und_Flur_14",
    "13_WALD_und_Flur_15",
    "13_WALD_und_Flur_16",
    "13_WALD_und_Flur_17",
    "13_WALD_und_Flur_18",
    "13_WALD_und_Flur_19",
    "13_WALD_und_Flur_20",
    "13_WALD_und_Flur_21",
    "13_WALD_und_Flur_22",
    "13_WALD_und_Flur_23",
    "13_WALD_und_Flur_24",
    "13_WALD_und_Flur_25",
    "14_Blumengruesse_aus_WALD_01",
    "14_Blumengruesse_aus_WALD_02",
    "14_Blumengruesse_aus_WALD_03",
    "14_Blumengruesse_aus_WALD_04",
    "14_Blumengruesse_aus_WALD_05",
    "14_Blumengruesse_aus_WALD_06",
    "14_Blumengruesse_aus_WALD_07",
    "14_Blumengruesse_aus_WALD_08",
    "14_Blumengruesse_aus_WALD_09",
    "15_WALDER_Wegzeichen_01",
    "15_WALDER_Wegzeichen_02",
    "15_WALDER_Wegzeichen_03",
    "15_WALDER_Wegzeichen_04",
    "15_WALDER_Wegzeichen_05",
    "15_WALDER_Wegzeichen_06",
    "15_WALDER_Wegzeichen_07",
    "15_WALDER_Wegzeichen_08",
    "15_WALDER_Wegzeichen_09",
    "15_WALDER_Wegzeichen_10",
    "15_WALDER_Wegzeichen_11",
    "15_WALDER_Wegzeichen_12",
    "15_WALDER_Wegzeichen_13",
    "15_WALDER_Wegzeichen_14",
    "16_WALDgeister_01",
    "16_WALDgeister_02",
    "16_WALDgeister_03",
    "16_WALDgeister_04",
    "16_WALDgeister_05",
    "16_WALDgeister_06",
    "16_WALDgeister_07"]
  }// end var endpoints

  var endpointURLs: [Foundation.URL?] {
    let imageURLs = endpoints.map { URL(string: "\(imageURLString)\($0)\(mimeTypeString)") }
    return imageURLs
  }// end var endpointURLs
  
  var endpointThumbURLs: [Foundation.URL?] {
    let imageURLs = endpoints.map { URL(string: "\(imageThumbURLString)\($0)\(mimeTypeString)") }
    return imageURLs
  }// end endpointThumURLs

  var endpointThumbGDIURLs: [Foundation.URL?] {
    let imageURLs = endpointsGDIThumbs.map { URL(string: "\(imageThumbURLString)\($0)\(mimeTypeString)") }
    return imageURLs
  }// end var endpointThumbURLs
  
  func set(_ data: Foundation.Data,
           for key: URL) -> Void {
    let nsData = data as NSData
    let keyString = key.absoluteString as NSString
    self.imageDataCache.setObject(nsData,
                                  forKey: keyString)
  }// end func set
  
  func get(for key: URL) -> Data? {
    let keyString = key.absoluteString as NSString
    return self.imageDataCache.object(forKey: keyString) as? Data
  }// end func get for key
  
  func initCache() throws -> Void {
    let module = try self.moduleTests.makeDevModule()
    endpointURLs.forEach {
      guard let url = $0 else { return }
      let expectation = self.expectation(description: "fetch\(url)")
      module.fetchImageData(from: url)
        .sink { completion in
          switch completion {
          case .finished:
            expectation.fulfill()
          case let .failure(encounteredError):
            expectation.fulfill()
          }// end switch completion
        } receiveValue: { data in
          self.set(data, for: url)
        }// end sink
        .store(in: &self.moduleTests.cancellables)
      waitForExpectations(timeout: 900)
    }// end for each
  }// end func initCache

  func initThumbCache() throws -> Void {
    let module = try self.moduleTests.makeDevModule()
    endpointThumbURLs.forEach {
      guard let url = $0 else { return }
      let expectation = self.expectation(description: "fetch\(url)")
      module.fetchImageData(from: url)
        .sink { completion in
          switch completion {
          case .finished:
            expectation.fulfill()
          case let .failure(encounteredError):
            expectation.fulfill()
          }// end switch completion
        } receiveValue: { data in
          self.set(data, for: url)
        }// end sink
        .store(in: &self.moduleTests.cancellables)
      waitForExpectations(timeout: 900)
    }// end for each
  }// end func initThumbCache
}// end extension final class OSCAArtWaldImageEndpointTests
#endif
