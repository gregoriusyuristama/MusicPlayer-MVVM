//
//  MusicListRepositoryProtocol.swift
//  MusicPlayer
//
//  Created by Gregorius Yuristama Nugraha on 5/3/24.
//

import Foundation
import Combine

protocol MusicListRepositoryProtocol {
    func getMusicListFromArtistName(artistName: String) -> AnyPublisher<[Music], Error>
}
