//
//  MusicResponse.swift
//  MusicPlayer
//
//  Created by Gregorius Yuristama Nugraha on 5/3/24.
//

import Foundation
// MARK: Music Response
struct MusicResponse: Decodable {
    let resultCount: Int
    let results: [MusicModel]
}

