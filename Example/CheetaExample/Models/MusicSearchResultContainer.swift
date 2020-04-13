//
//  MusicSearchResultContainer.swift
//  MusicAppMVVM
//
//  Created by Mahabaleshwar on 28/01/20.
//  Copyright © 2020 TW. All rights reserved.
//

import Foundation
import Cheeta


// MARK: - MusicSearchResultContainer
struct MusicSearchResultContainer: Codable {
    let resultCount: Int
    let results: [MusicSearchResult]
}

// MARK: - Result
struct MusicSearchResult: Codable {
    let wrapperType: String?
    let kind: String?
    let artistID, collectionID, trackID: Int?
    let artistName: String?
    let collectionName, trackName, collectionCensoredName, trackCensoredName: String?
    let artistViewURL, collectionViewURL, trackViewURL: URL?
    let previewURL: URL?
    let artworkUrl30, artworkUrl60, artworkUrl100: URL?
    let collectionPrice, trackPrice: Double?
    let releaseDate: String?
    let collectionExplicitness, trackExplicitness: String?
    let discCount, discNumber, trackCount, trackNumber: Int?
    let trackTimeMillis: Int?
    let country: String?
    let currency: String?
    let primaryGenreName: String?
    let isStreamable: Bool?
    let collectionArtistID: Int?
    let collectionArtistName: String?

    enum CodingKeys: String, CodingKey {
        case wrapperType, kind
        case artistID = "artistId"
        case collectionID = "collectionId"
        case trackID = "trackId"
        case artistName, collectionName, trackName, collectionCensoredName, trackCensoredName
        case artistViewURL = "artistViewUrl"
        case collectionViewURL = "collectionViewUrl"
        case trackViewURL = "trackViewUrl"
        case previewURL = "previewUrl"
        case artworkUrl30, artworkUrl60, artworkUrl100, collectionPrice, trackPrice, releaseDate, collectionExplicitness, trackExplicitness, discCount, discNumber, trackCount, trackNumber, trackTimeMillis, country, currency, primaryGenreName, isStreamable
        case collectionArtistID = "collectionArtistId"
        case collectionArtistName
    }
}


extension MusicSearchResult {
    var title: String? {
        return self.trackName
    }
    
    var musicWrapper: URL? {
        return self.artworkUrl100
    }
    
    var subTitle: String? {
        return self.artistName
    }
    
    var caption: String? {
        return self.collectionName
    }
    
    
    
}


enum Country: String, Codable {
    case usa = "USA"
}

enum Currency: String, Codable {
    case usd = "USD"
}

enum Kind: String, Codable {
    case song = "song"
}

enum PrimaryGenreName: String, Codable {
    case christianGospel = "Christian & Gospel"
    case pop = "Pop"
    case vocal = "Vocal"
}

enum WrapperType: String, Codable {
    case track = "track"
}


enum MusicEnpoints: APIEndPoint {
    
    var relativePath: String {
        switch self {
        case .search:
            return "search"
        }
    }
    
    
    case search
}
