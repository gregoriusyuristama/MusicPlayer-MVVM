//
//  MusicListRepository.swift
//  MusicPlayer
//
//  Created by Gregorius Yuristama Nugraha on 5/3/24.
//

import Foundation
import Combine

class MusicListRepository: MusicListRepositoryProtocol {
    private let musicApiService: ItunesServiceProtocol
    
    init(musicApiService: ItunesServiceProtocol) {
        self.musicApiService = musicApiService
    }
    
    func getMusicListFromArtistName(artistName: String) -> AnyPublisher<[Music], any Error> {
        return musicApiService.getMusicListFromArtistName(artistName: artistName)
            .catch({ error in
                return Fail(error: error).eraseToAnyPublisher()
            })
            .map( { musicResponse in
                musicResponse.results.map { music in
                    music.toMusic()
                }
            })
            .eraseToAnyPublisher()
    }
    
    
}
