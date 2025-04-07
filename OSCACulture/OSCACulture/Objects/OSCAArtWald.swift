//
//  OSCAArtWald.swift
//  OSCACulture
//
//  Created by Stephan Breidenbach on 15.07.22.
//  Reviewed by Stephan Breidenbach on 21.09.22
//
import Foundation
import OSCAEssentials

public struct OSCAArtWald: OSCAParseClassObject {
  /// Auto generated id
  public private(set) var objectId                        : String?
  /// UTC date when the object was created
  public private(set) var createdAt                       : Date?
  /// UTC date when the object was changed
  public private(set) var updatedAt                       : Date?
  
  public var streetLightNo: Int?             // Parse-name: "LATERNE_NR"
  public var artistTitle: String?            // Parse-name: "KUENSTLER"
  public var description: String?            // Parse-name: "ORTSBESCHREIBUNG"
  public var hotspotTitle: String?           // Parse-name: "TITEL_HOTSPOT"
  public var geopoint: ParseGeoPoint?        // Parse-name: "geopoint"
  public var summary: String?                // Parse-name: "KURZTEXT"
  public var streetLightID: UInt8?           // Parse-name: "ID_LATERNE"
  public var imageGallery: [String?]?        // Parse-name: "KW_IMAGEGALLERY"
  public var artisanCrafts: [String?]?       // Parse-name: "KUENSTLER_KUNSTFORM"
  public var artistsPortrait: [String?]?     // Parse-name: "KUENSTLER_IMAGES"
  public var artistsLink: [String?]?         // Parse-name: "KUENSTLER_LINK"
  public var artWaldID: Int?                 // Parse-name: "ID_KIW"
  public var artistsPrivateLink: [String?]?  // Parse-name: "KUENSTLER_URL"
  public var titleImage: String?             // Parse-name: "KW_TITLEIMAGE"
  public var artistsName: [String?]?         // Parse-name: "artists"
  public var minor: Int?                     // Parse-name: "Minor"
  public var major: Int?                     // Parse-name: "Major"
  public var uUID: String?                   // Parse-name: "UUID"
  public var proximity: OSCAArtWald.Proximity = .unknown
  /// for debug output
  var debugDescription: String { /*"UUID: \(uUID ?? "Unknown"), " + */
                                 "major: \(major != nil ? String(major!) : "Unknown"), " +
                                 "minor: \(minor != nil ? String(minor!) : "Unknown"), " +
                                 "proximity: \(proximity)" }
  
  enum CodingKeys: String, CodingKey {
    case objectId                                     //
    case createdAt                                    //
    case updatedAt                                    //
    case streetLightNo      = "LATERNE_NR"            //
    case artistTitle        = "KUENSTLER"             //
    case description        = "ORTSBESCHREIBUNG"      //
    case hotspotTitle       = "TITEL_HOTSPOT"         //
    case geopoint           = "geopoint"              //
    case summary            = "KURZTEXT"              //
    case streetLightID      = "ID_LATERNE"            //
    case imageGallery       = "KW_IMAGEGALLERY"       //
    case artisanCrafts      = "KUENSTLER_KUNSTFORM"   //
    case artistsPortrait    = "KUENSTLER_IMAGES"      //
    case artistsLink        = "KUENSTLER_LINK"        //
    case artWaldID          = "ID_KIW"                //
    case artistsPrivateLink = "KUENSTLER_URL"         //
    case titleImage         = "KW_TITLEIMAGE"         //
    case artistsName        = "artists"               //
    case minor              = "Minor"                 //
    case major              = "Major"                 //
    case uUID               = "UUID"                  //
  }// end enum CodingKeys
}// end public struct OSCAArtWald

// MARK: - image URL thumbs
extension OSCAArtWald {
  var thumbsURLString: String {
    return "https://geoportal.solingen.de/buergerservice1/ressourcen/kunstinwald/thumbs/"
  }// end var thumbsURLString
  
  var thumbsImageMimeType: String {
    return ".jpg"
  }// end var thumbsImageMimeType
  
  /// ```https://geoportal.solingen.de/buergerservice1/ressourcen/kunstinwald/thumbs/01_titel_WALD_markiert.jpg```
  public var titleImageURLThumb: URL? {
    if let titleImage = self.titleImage {
      let urlString = "\(thumbsURLString)\(titleImage)\(thumbsImageMimeType)"
      return URL(string: urlString)
    } else {
      return nil
    }// end if
  }// end var titleImageURLThumb
  
  public var imageGalleryURLThumbs: [URL] {
    if let imageGallery = self.imageGallery {
      let mappedImageGallery = imageGallery.compactMap { $0 }
      if !mappedImageGallery.isEmpty {
        let mappedImageGalleryURLs = mappedImageGallery.compactMap { URL(string: "\(thumbsURLString)\($0)\(thumbsImageMimeType)") }
        return mappedImageGalleryURLs
      } else {
        return []
      }// end if
    } else {
      return []
    }// end if
  }// end var imageGalleryURLThumbs
  
  public var artistsPortraitURLThumbs: [URL] {
    if let artistsPortrait = self.artistsPortrait {
      let mappedArtistsPortrait = artistsPortrait.compactMap { $0 }
      if !mappedArtistsPortrait.isEmpty {
        let mappedArtistsPortraitURLs = mappedArtistsPortrait.compactMap { URL(string: "\(thumbsURLString)\($0)\(thumbsImageMimeType)") }
        return mappedArtistsPortraitURLs
      } else {
        return []
      }// end if
    } else {
      return []
    }// end if
  }// end var artistsPortraitURLThumbs
}// end extension public struct OSCAArtWald

// MARK: - image URLs
extension OSCAArtWald {
  var imageURLString: String {
    return "https://geoportal.solingen.de/buergerservice1/ressourcen/kunstinwald/"
  }// end var imageURLString
  
  var imageMimeType: String {
    return ".jpg"
  }// end var imageMimeType
  
  /// ```https://geoportal.solingen.de/buergerservice1/ressourcen/kunstinwald/01_titel_WALD_markiert.jpg```
  public var titleImageURL: URL? {
    if let titleImage = self.titleImage {
      let urlString = "\(imageURLString)\(titleImage)\(imageMimeType)"
      return URL(string: urlString)
    } else {
      return nil
    }// end if
  }// end var titleImageURL
  
  public var imageGalleryURLs: [URL] {
    if let imageGallery = self.imageGallery {
      let mappedImageGallery = imageGallery.compactMap { $0 }
      if !mappedImageGallery.isEmpty {
        let mappedImageGalleryURLs = mappedImageGallery.compactMap { URL(string: "\(imageURLString)\($0)\(imageMimeType)") }
        return mappedImageGalleryURLs
      } else {
        return []
      }// end if
    } else {
      return []
    }// end if
  }// end var imageGalleryURLs
  
  public var artistsPortraitURLs: [URL] {
    if let artistsPortrait = self.artistsPortrait {
      let mappedArtistsPortrait = artistsPortrait.compactMap { $0 }
      if !mappedArtistsPortrait.isEmpty {
        let mappedArtistsPortraitURLs = mappedArtistsPortrait.compactMap { URL(string: "\(imageURLString)\($0)\(imageMimeType)") }
        return mappedArtistsPortraitURLs
      } else {
        return []
      }// end if
    } else {
      return []
    }// end if
  }// end var artistsPortraitURLs
}// end extension public struct OSCAArtWald

extension OSCAArtWald {
  public var artistHomepageURLs: [URL] {
    if let artistHomepages = self.artistsLink {
      let mappedArtistHomepages = artistHomepages.compactMap { $0 }
      if !mappedArtistHomepages.isEmpty {
        let mappedArtistHomepageURLs = mappedArtistHomepages.compactMap { URL(string: $0) }
        return mappedArtistHomepageURLs
      } else {
        return []
      }// end if
    } else {
      return []
    }// end if
  }// end var artistHomepageURLs
}// end extension public struct OSCAArtWald

extension OSCAArtWald {
  public struct Artist {
    public var name: String?
    public var artisanCraft: String?
    public var thumbImageURL: URL?
    public var homepageURL: URL?
  }// end public struct Artist
}// end extension public struct OSCAArtWald
extension OSCAArtWald.Artist: Equatable {}
extension OSCAArtWald.Artist: Codable {}
extension OSCAArtWald.Artist: Hashable {}

extension OSCAArtWald {
  public var artistList: [OSCAArtWald.Artist]? {
    guard let artistsName = artistsName,
          let count = self.artistsName?.count,
          count > 0,
          let artisanCrafts = artisanCrafts,
          !artistsPortraitURLThumbs.isEmpty,
          !artistHomepageURLs.isEmpty,
          artistsName.count == count,
          artistsPortraitURLThumbs.count == count,
          artistHomepageURLs.count == count
    else { return nil }
    var array: [OSCAArtWald.Artist] = []
    for i in 0...(count - 1) {
      let item = OSCAArtWald.Artist(name: artistsName[i],
                                    artisanCraft: artisanCrafts[i],
                                    thumbImageURL: artistsPortraitURLThumbs[i],
                                    homepageURL: artistHomepageURLs[i])
      array.append(item)
    }// end for i
    return array
  }// end public var artists
}// end extension public struct OSCAArtWald

// MARK: - Equatable conformance
extension OSCAArtWald: Equatable {}
extension OSCAArtWald: Codable {}
extension OSCAArtWald: Hashable {}

extension OSCAArtWald {
  public enum Proximity:Int {
    case immediate = 0
    case near = 1
    case far = 2
    case unknown = 99
  }// end enum Proximity
}// end extension public struct OSCAArtWald

extension OSCAArtWald.Proximity: Equatable {}
extension OSCAArtWald.Proximity: Codable {}
extension OSCAArtWald.Proximity: Hashable {}

public extension Array where Element == OSCAArtWald {
  /// debug textual representation of `[OSCAArtWald]`
  var debugDescription: String {
    return self.compactMap { $0.debugDescription }
      .joined(separator: "\n")
  }// end debugDescription
}// end extension Array

extension OSCAArtWald {
  /// Parse class name
  public static var parseClassName : String { return "KunstInWald" }
}// end extension OSCAArtWald
