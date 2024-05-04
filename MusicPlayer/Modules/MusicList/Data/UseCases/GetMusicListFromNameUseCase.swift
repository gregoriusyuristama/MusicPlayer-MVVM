//
//  GetMusicListFromNameUseCase.swift
//  MusicPlayer
//
//  Created by Gregorius Yuristama Nugraha on 5/5/24.
//

import Foundation
import Combine

protocol GetMusicListUseCaseProtocol {
    var musicListRepository: MusicListRepositoryProtocol { get }
    
    func call(trackName: String) -> AnyPublisher<[Music], Error>
}

class GetMusicListFromNameUseCase: GetMusicListUseCaseProtocol {
    var musicListRepository: MusicListRepositoryProtocol
    
    init(musicListRepository: MusicListRepositoryProtocol = MusicListRepository()) {
        self.musicListRepository = musicListRepository
    }
    
    func call(trackName: String) -> AnyPublisher<[Music], Error> {
        return musicListRepository.getMusicListFromTrackName(trackName: trackName)
    }
}
