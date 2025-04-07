//
//  OSCACulture+images.swift
//  OSCACulture
//
//  Created by Stephan Breidenbach on 11.03.24.
//

import Foundation
import OSCAEssentials
import OSCANetworkService
import Combine

// MARK: - Images

extension OSCACulture {
  public typealias ImageDataPublisher = AnyPublisher<Foundation.Data, OSCACultureError>
  
  public func fetchImageData(from url: URL) -> OSCACulture.ImageDataPublisher {
    let publisher: AnyPublisher<Foundation.Data, OSCANetworkError> = networkService
      .fetch(url)
    return publisher
      .mapError(transformError)
      .subscribe(on: OSCAScheduler.backgroundWorkScheduler)
      .eraseToAnyPublisher()
  } // end func fetchImageData from url
} // end extension public struct OSCACulture
