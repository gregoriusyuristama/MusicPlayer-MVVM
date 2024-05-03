//
//  MusicListViewModel.swift
//  MusicPlayer
//
//  Created by Gregorius Yuristama Nugraha on 5/3/24.
//

import Foundation
import Combine

class MusicListViewModel {
    private let musicListRepository: MusicListRepositoryProtocol
    private let output: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    init(musicListRepository: MusicListRepository = MusicListRepository(musicApiService: ItunesService())) {
        self.musicListRepository = musicListRepository
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .searchTriggered(let searchText):
                self?.handleSearchArtistNAme(artistName: searchText)
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    func handleSearchArtistNAme(artistName: String) {
        output.send(.toggleSearch(isEnabled: false))
        musicListRepository.getMusicListFromArtistName(artistName: artistName).sink { [weak self] completion in
            self?.output.send(.toggleSearch(isEnabled: true))
            if case .failure(let error) = completion {
                self?.output.send(.fetchMusicListDidFail(error: error))
            }
        } receiveValue: { [weak self] musicList in
            self?.output.send(.fetchMusicListDidSucceed(musicList: musicList))
        }.store(in: &cancellables)

    }
    
}

// MARK: Input Enum
extension MusicListViewModel {
    enum Input {
        case searchTriggered(String)
    }
}

// MARK: Output Enum
extension MusicListViewModel {
    enum Output {
        case fetchMusicListDidFail(error: Error)
        case fetchMusicListDidSucceed(musicList: [Music])
        case toggleSearch(isEnabled: Bool)
    }
}
