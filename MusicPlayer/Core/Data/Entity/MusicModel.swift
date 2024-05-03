//
//  MusicModel.swift
//  MusicPlayer
//
//  Created by Gregorius Yuristama Nugraha on 5/3/24.
//
import Foundation

// MARK: MusicModel
struct MusicModel: Decodable {
    let wrapperType: String?
    let kind: String?
    let artistID, collectionID, trackID: Int?
    let artistName: String?
    let collectionName, trackName, collectionCensoredName, trackCensoredName: String?
    let collectionArtistID: Int?
    let collectionArtistName: String?
    let artistViewURL, collectionViewURL, trackViewURL: String?
    let previewURL: String?
    let artworkUrl30: String?
    let artworkUrl60, artworkUrl100: String?
    let collectionPrice: Double?
    let trackPrice: Double?
    let releaseDate: String?
    let collectionExplicitness: String?
    let trackExplicitness: String?
    let discCount, discNumber, trackCount, trackNumber: Int?
    let trackTimeMillis: Int?
    let country: String?
    let currency: String?
    let primaryGenreName: String
    let isStreamable: Bool?
    let collectionArtistViewURL: String?
    let trackRentalPrice, collectionHDPrice, trackHDPrice, trackHDRentalPrice: Double?
    let contentAdvisoryRating, shortDescription, longDescription: String?
    let hasITunesExtras: Bool?
    let feedURL: String?
    let artworkUrl600: String?
    let genreIDS, genres: [String]?
    let copyright, resultDescription: String?
}

// MARK: Convert to Music on presentation
extension MusicModel {
    func toMusic() -> Music {
        let music = Music(songName: self.trackName ?? "No Track Name", artistName: self.artistName ?? "No Artist Name")
        return music
    }
}
