//
//  OSCACulture.swift
//  OSCACulture
//
//  Created by Stephan Breidenbach on 15.07.22.
//

import Combine
import Foundation
import OSCAEssentials
import OSCANetworkService

/// OSCA corona module
public class OSCACulture: OSCAModule {
  let transformError: (OSCANetworkError) -> OSCACultureError = { networkError in
    switch networkError {
    case OSCANetworkError.invalidResponse:
      return OSCACultureError.networkInvalidResponse
    case OSCANetworkError.invalidRequest:
      return OSCACultureError.networkInvalidRequest
    case let OSCANetworkError.dataLoadingError(statusCode: code, data: data):
      return OSCACultureError.networkDataLoading(statusCode: code, data: data)
    case let OSCANetworkError.jsonDecodingError(error: error):
      return OSCACultureError.networkJSONDecoding(error: error)
    case OSCANetworkError.isInternetConnectionError:
      return OSCACultureError.networkIsInternetConnectionFailure
    } // end switch case
  } // end let transformError closure

  /// module DI container
  var moduleDIContainer: OSCACultureDIContainer!

  /// version of the module
  public var version: String = "1.0.5"
  /// bundle prefix of the module
  public var bundlePrefix: String = "de.osca.culture"
  /// module `Bundle`
  ///
  /// **available after module initialization only!!!**
  public internal(set) static var bundle: Bundle!

  var networkService: OSCANetworkService!
  var locationManager: OSCALocationManager?

  public private(set) var userDefaults: UserDefaults

  /**
   create module and inject module dependencies

   ** This is the only way to initialize the module!!! **
   - Parameter moduleDependencies: module dependencies
   ```
   call: OSCACulture.create(with moduleDependencies)
   ```
   */
  public static func create(with moduleDependencies: OSCACulture.Dependencies) -> OSCACulture {
    let module: OSCACulture = OSCACulture(networkService: moduleDependencies.networkService,
                                          userDefaults: moduleDependencies.userDefaults)
    module.moduleDIContainer = OSCACultureDIContainer(dependencies: moduleDependencies)
    return module
  } // end public static create

  /// initializes the events module
  ///  - Parameter networkService: Your configured network service
  private init(networkService: OSCANetworkService,
               userDefaults: UserDefaults) {
    self.networkService = networkService
    self.userDefaults = userDefaults
    var bundle: Bundle?
    #if SWIFT_PACKAGE
      bundle = Bundle.module
    #else
      bundle = Bundle(identifier: bundlePrefix)
    #endif
    guard let bundle: Bundle = bundle else { fatalError("Module bundle not initialized!") }
    Self.bundle = bundle
  } // end public init
} // end public struct OSCACulture

extension OSCACulture {
  public struct Dependencies {
    public let networkService: OSCANetworkService
    public let userDefaults: UserDefaults
    public let analyticsModule: OSCAAnalyticsModule?
    public init(networkService: OSCANetworkService,
                userDefaults: UserDefaults,
                analyticsModule: OSCAAnalyticsModule? = nil
    ) {
      self.networkService = networkService
      self.userDefaults = userDefaults
      self.analyticsModule = analyticsModule
    } // end public init
  } // end public struct OSCACulture.Dependencies
} // end extension public struct OSCACulture

// MARK: fetch all ArtWald

extension OSCACulture {
  public typealias ArtWaldPublisher = AnyPublisher<[OSCAArtWald], OSCACultureError>

  /// Fetches all `ArtWald` from parse server in background
  /// - Parameter maxCount: Limits the amount of POIs that gets downloaded from the server
  /// - Parameter query: HTTP query parameter
  /// - Returns: Publisher with a list of all `ArtWald` on the `Output` and possible `OSCACultureError`s on the `Fail`channel
  ///
  /// [SWIFT_ACTIVE_COMPILATION_CONDITIONS](https://medium.com/@ytyubox/xcode-preprocessing-with-custom-flags-in-swift-4bfde6e7a608)
  public func fetchAllArtWald(maxCount: Int = 1000,
                              query: [String: String] = [:]) -> ArtWaldPublisher {
    // limit is greater 0!
    guard maxCount > 0 else {
      // return an empty list of POIs immediately
      return Empty(completeImmediately: true,
                   outputType: [OSCAArtWald].self,
                   failureType: OSCACultureError.self).eraseToAnyPublisher()
    } // end guard
    var parameters = query
    parameters["limit"] = "\(maxCount)"

    var headers = networkService.config.headers
    if let sessionToken = userDefaults.string(forKey: "SessionToken") {
      headers["X-Parse-Session-Token"] = sessionToken
    }

    var publisher: AnyPublisher<[OSCAArtWald], OSCANetworkError>
    #if MOCKNETWORK
    publisher = networkService.fetch(OSCABundleRequestResource<OSCAArtWald>
      .artWald(bundle: Self.bundle, fileName: "OSCAArtWald_Dev_Home.json"))
    #else
      publisher = networkService.fetch(OSCAClassRequestResource
        .artWald(baseURL: networkService.config.baseURL,
                 headers: headers,
                 query: parameters)) // end fetch
    #endif
    return publisher
      .mapError(transformError)
      // fetch arts in background
      .subscribe(on: OSCAScheduler.backgroundWorkScheduler)
      .eraseToAnyPublisher()
  } // end public func fetchAllPOIs
} // end extension public struct OSCACulture



// MARK: - Location Manager

extension OSCACulture {
  public typealias ArtWaldBeaconsPublisher = AnyPublisher<[OSCAArtWald], OSCACultureError>

  /// first get location state
  public func getLocationState(for artWaldItems: [OSCAArtWald]) -> OSCALocationStatePublisher {
    guard let locationManager = OSCALocationManager(with: artWaldItems)
    else { return Empty(completeImmediately: true).eraseToAnyPublisher() }
    self.locationManager = locationManager
    let publisher: OSCALocationStatePublisher =
      locationManager
        .getState()
    return publisher
  } // end func getLocationState

  /// second run find beacons
  public func findBeacons() -> ArtWaldBeaconsPublisher {
    guard let locationManager = locationManager else { return Fail(outputType: [OSCAArtWald].self, failure: OSCACultureError.beaconFetch).eraseToAnyPublisher() }
    let publisher: ArtWaldBeaconsPublisher =
      locationManager
        .fetchBeacons()
        .mapError { switch $0 { case .timeout:
          return OSCACultureError.beaconFetch } }
        .asyncMap { Array($0).compactMap { OSCAArtWald(with: $0) } }
        .eraseToAnyPublisher()
    return publisher
  } // end public func findBeacons for art Wald items
} // end extension public struct OSCACulture
