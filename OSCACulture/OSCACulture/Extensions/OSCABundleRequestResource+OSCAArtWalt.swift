//
//  OSCABundleRequestResource+OSCAArtWalt.swift
//  OSCACulture
//
//  Created by Stephan Breidenbach on 15.02.24.
//

import Foundation
import OSCANetworkService

extension OSCABundleRequestResource {
  /// `BundleRequestResource` for art wald data
  /// - Parameters:
  ///   - bundle: bundle in which the JSON-file is bundled
  ///   - fileName: JSON-file name with postfix
  /// - Returns: A ready to use `OSCABundleRequestResource`
  static func artWald(bundle: Bundle,
                      fileName: String) -> OSCABundleRequestResource {
    return OSCABundleRequestResource(bundle:bundle,
                                     fileName: fileName)
  }// end static func artWald
}// end extension public struct OSCABundleRequestResource
