//
//  GetMusicListFromNameUseCase.swift
//  MusicPlayer
//
//  Created by Gregorius Yuristama Nugraha on 5/5/24.
//

import Foundation
import Combine

protocol GetMusicListFromNameUseCaseProtocol {
    var musicListRepository: MusicListRepositoryProtocol { get }
    
    func call(trackName: String) -> AnyPublisher<[Music], Error>
}

class GetMusicListFromNameUseCase: GetMusicListFromNameUseCaseProtocol {
    var musicListRepository: MusicListRepositoryProtocol
    
    init(musicListRepository: MusicListRepositoryProtocol = MusicListRepository()) {
        self.musicListRepository = musicListRepository
    }
    
    func call(trackName: String) -> AnyPublisher<[Music], Error> {
        return musicListRepository.getMusicListFromTrackName(trackName: trackName)
    }
}
