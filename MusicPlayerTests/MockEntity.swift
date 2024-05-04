//
//  MockEntity.swift
//  MusicPlayerTests
//
//  Created by Gregorius Yuristama Nugraha on 5/4/24.
//

import Foundation
@testable import MusicPlayer


class MockEntity {
    static let musicResponse: MusicResponse = .init(resultCount: 3, results: musicModelList)
    
    static let musicModelList: [MusicModel] = [
        .init(wrapperType: "", kind: "", artistID: 0, collectionID: 0, trackID: 0, artistName: "Artist 1", collectionName: "", trackName: "Song 1", collectionCensoredName: "", trackCensoredName: "", collectionArtistID: nil, collectionArtistName: "", artistViewURL: "", collectionViewURL: "", trackViewURL: "", previewUrl: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview125/v4/ae/ab/1d/aeab1df3-29b8-e98d-04f2-c372d3aa7861/mzaf_8839786800171875369.plus.aac.p.m4a", artworkUrl30: "", artworkUrl60: "", artworkUrl100: "", collectionPrice: nil, trackPrice: nil, releaseDate: "", collectionExplicitness: "", trackExplicitness: "", discCount: nil, discNumber: nil, trackCount: nil, trackNumber: nil, trackTimeMillis: nil, country: "", currency: "", primaryGenreName: "", isStreamable: nil, collectionArtistViewURL: nil, trackRentalPrice: nil, collectionHDPrice: nil, trackHDPrice: nil, trackHDRentalPrice: nil, contentAdvisoryRating: nil, shortDescription: nil, longDescription: nil, hasITunesExtras: nil, feedURL: nil, artworkUrl600: nil, genreIDS: nil, genres: nil, copyright: nil, resultDescription: nil),
        .init(wrapperType: "", kind: "", artistID: 0, collectionID: 0, trackID: 0, artistName: "Artist 2", collectionName: "", trackName: "Song 2", collectionCensoredName: "", trackCensoredName: "", collectionArtistID: nil, collectionArtistName: "", artistViewURL: "", collectionViewURL: "", trackViewURL: "", previewUrl: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview125/v4/25/dd/6a/25dd6ad6-39c6-32c3-c97e-50ec9422121e/mzaf_1878860000998513744.plus.aac.p.m4a", artworkUrl30: "", artworkUrl60: "", artworkUrl100: "", collectionPrice: nil, trackPrice: nil, releaseDate: "", collectionExplicitness: "", trackExplicitness: "", discCount: nil, discNumber: nil, trackCount: nil, trackNumber: nil, trackTimeMillis: nil, country: "", currency: "", primaryGenreName: "", isStreamable: nil, collectionArtistViewURL: nil, trackRentalPrice: nil, collectionHDPrice: nil, trackHDPrice: nil, trackHDRentalPrice: nil, contentAdvisoryRating: nil, shortDescription: nil, longDescription: nil, hasITunesExtras: nil, feedURL: nil, artworkUrl600: nil, genreIDS: nil, genres: nil, copyright: nil, resultDescription: nil),
        .init(wrapperType: "", kind: "", artistID: 0, collectionID: 0, trackID: 0, artistName: "Artist 3", collectionName: "", trackName: "Song 3", collectionCensoredName: "", trackCensoredName: "", collectionArtistID: nil, collectionArtistName: "", artistViewURL: "", collectionViewURL: "", trackViewURL: "", previewUrl: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview125/v4/50/f1/31/50f131e7-edb0-fb76-fa1f-8da6b78813b8/mzaf_4337393000404489784.plus.aac.p.m4a", artworkUrl30: "", artworkUrl60: "", artworkUrl100: "", collectionPrice: nil, trackPrice: nil, releaseDate: "", collectionExplicitness: "", trackExplicitness: "", discCount: nil, discNumber: nil, trackCount: nil, trackNumber: nil, trackTimeMillis: nil, country: "", currency: "", primaryGenreName: "", isStreamable: nil, collectionArtistViewURL: nil, trackRentalPrice: nil, collectionHDPrice: nil, trackHDPrice: nil, trackHDRentalPrice: nil, contentAdvisoryRating: nil, shortDescription: nil, longDescription: nil, hasITunesExtras: nil, feedURL: nil, artworkUrl600: nil, genreIDS: nil, genres: nil, copyright: nil, resultDescription: nil)
    ]
    
    static let musicList: [Music] = [
        .init(
            songName: "Song 1",
            artistName: "Artist 1",
            audioUrl: URL(string: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview125/v4/ae/ab/1d/aeab1df3-29b8-e98d-04f2-c372d3aa7861/mzaf_8839786800171875369.plus.aac.p.m4a")
        ),
        .init(
            songName: "Song 2",
            artistName: "Artist 2",
            audioUrl: URL(string: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview125/v4/25/dd/6a/25dd6ad6-39c6-32c3-c97e-50ec9422121e/mzaf_1878860000998513744.plus.aac.p.m4a")
        ),
        .init(
            songName: "Song 3",
            artistName: "Artist 3",
            audioUrl: URL(string: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview125/v4/50/f1/31/50f131e7-edb0-fb76-fa1f-8da6b78813b8/mzaf_4337393000404489784.plus.aac.p.m4a")
        ),

    ]
    
    static let singleMusic: Music = .init(
        songName: "Song 1",
        artistName: "Artist 1",
        audioUrl: URL(string: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview125/v4/50/f1/31/50f131e7-edb0-fb76-fa1f-8da6b78813b8/mzaf_4337393000404489784.plus.aac.p.m4a")
    )
    
    static let musicListBrokenUrl: [Music] = [
        .init(
            songName: "Broken Song 1",
            artistName: "Broken Artist 1",
            audioUrl: URL(string: "Invalid URL")
        ),
        .init(
            songName: "Broken Song 2",
            artistName: "Broken Artist 2",
            audioUrl: URL(string: "Broken URL")
        )
    ]
}
