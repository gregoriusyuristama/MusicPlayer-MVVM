//
//  Music.swift
//  MusicPlayer
//
//  Created by Gregorius Yuristama Nugraha on 5/3/24.
//

import Foundation

struct Music: Equatable {
    let songName: String
    let artistName: String
    let audioUrl: URL?
    let songArtwork: URL?
}

// MARK: Dummy Data
extension Music {
    static let mockMusicList: [Music] = [
        .init(songName: "Song 1", artistName: "Artist 1", audioUrl: nil, songArtwork: nil),
        .init(songName: "Song 2", artistName: "Artist 2", audioUrl: nil, songArtwork: nil),
        .init(songName: "Song 3", artistName: "Artist 3", audioUrl: nil, songArtwork: nil),
    ]
}
