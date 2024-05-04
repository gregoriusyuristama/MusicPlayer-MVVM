//
//  MusicListViewModel.swift
//  MusicPlayer
//
//  Created by Gregorius Yuristama Nugraha on 5/3/24.
//

import Foundation
import Combine

class MusicListViewModel {
    private let output: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    private let getMusicListFromNameUseCase: GetMusicListUseCaseProtocol
    
    init(getMusicUseCase: GetMusicListUseCaseProtocol = GetMusicListFromNameUseCase()) {
        self.getMusicListFromNameUseCase = getMusicUseCase
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .searchTriggered(let searchText):
                self?.handleSearchTrackName(trackName: searchText)
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    func handleSearchTrackName(trackName: String) {
        output.send(.toggleSearch(isSearching: true))
        getMusicListFromNameUseCase.call(trackName: trackName).sink { [weak self] completion in
            self?.output.send(.toggleSearch(isSearching: false))
            if case .failure(let error) = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000), execute: { [weak self] in
                    self?.output.send(.fetchMusicListDidFail(error: error))
                })
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
        case toggleSearch(isSearching: Bool)
    }
}
