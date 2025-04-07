//
//  OSCAClassRequestResource+ArtWald.swift
//  OSCACulture
//
//  Created by Stephan Breidenbach on 15.07.22.
//

import Foundation
import OSCANetworkService

extension OSCAClassRequestResource {
  /// ```console
  ///curl -vX GET \
  /// -H "X-Parse-Application-Id: ApplicationID}" \
  /// -H "X-PARSE-CLIENT-KEY: ClientKey" \
  /// -H 'Content-Type: application/json' \
  /// 'https://parse-dev.solingen.de/classes/KunstInWald'
  /// ```
  static func artWald(baseURL: URL, headers: [String: CustomStringConvertible], query: [String: CustomStringConvertible] = [:]) -> OSCAClassRequestResource {
    let parseClass = OSCAArtWald.parseClassName
    return OSCAClassRequestResource(baseURL: baseURL,
                                                      parseClass: parseClass,
                                                      parameters: query,
                                                      headers: headers)
  }// end static func artWald
}// end extension public struct OSCAClassRequestResource

