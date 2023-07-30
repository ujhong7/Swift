//
//  Music.swift
//  MVCmusicApp
//
//  Created by yujaehong on 2023/07/28.
//

import Foundation

struct MusicData: Codable {
    let resultCount: Int
    let results: [Music]
}

struct Music: Codable {
    let songName: String?
    let artistName: String?
    let albumName: String?
    let imageUrl: String?

    enum CodingKeys: String, CodingKey {
        case songName = "trackName"
        case artistName
        case albumName = "collectionName"
        case imageUrl = "artworkUrl100"
    }
}


enum NetworkError: Error {
    case networkingError
    case dataError
    case parseError
}
