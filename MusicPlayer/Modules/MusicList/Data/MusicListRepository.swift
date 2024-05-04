//
//  MusicListRepository.swift
//  MusicPlayer
//
//  Created by Gregorius Yuristama Nugraha on 5/3/24.
//

import Foundation
import Combine

class MusicListRepository: MusicListRepositoryProtocol {
    private let musicApiService: MusicServiceProtocol
    
    init(musicApiService: MusicServiceProtocol) {
        self.musicApiService = musicApiService
    }
    
    func getMusicListFromTrackName(trackName: String) -> AnyPublisher<[Music], Error> {
        return musicApiService.getMusicListFromTrackName(trackName: trackName)
            .catch({ error in
                return Fail(error: error).eraseToAnyPublisher()
            })
            .map( { musicResponse in
                musicResponse.results.compactMap { music in
                    music.toMusic()
                }
            })
            .eraseToAnyPublisher()
    }
    
    
}
