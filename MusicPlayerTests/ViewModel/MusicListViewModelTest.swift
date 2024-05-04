//
//  MusicListViewModelTest.swift
//  MusicPlayerTests
//
//  Created by Gregorius Yuristama Nugraha on 5/4/24.
//

import XCTest
import Combine
@testable import MusicPlayer

class MusicListViewModelTest: XCTestCase {
    
    private var sut: MusicListViewModel!
    private var mockUseCase: MockGetMusicListUseCase!
    private var cancellables = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockUseCase = MockGetMusicListUseCase()
        sut = MusicListViewModel(getMusicUseCase: mockUseCase)
    }
    
    override func tearDownWithError() throws {
        try super.setUpWithError()
        mockUseCase = nil
        sut = nil
        cancellables.removeAll()
    }
    
    func testFetchMusicSuceed() {
        // given
        let expectedMusicList = MockEntity.musicList
        mockUseCase.willSuceed = true
        let expectation = expectation(description: "Music Fetched Succesfully")
        let testInput = PassthroughSubject<MusicListViewModel.Input, Never>()
        
        // when
        sut.transform(input: testInput.eraseToAnyPublisher())
            .sink { output in
                switch output {
                case .fetchMusicListDidSucceed(let musicList):
                    XCTAssertEqual(musicList.count, expectedMusicList.count) 
                    expectation.fulfill()
                default:
                    break
                }
            }
            .store(in: &cancellables)
        
        testInput.send(.searchTriggered("test"))
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFetchMusicFailed() {
        // given
        let expectedError = NSError(domain: "com.example", code: 404, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch music"])
        mockUseCase.willSuceed = false
        let expectation = expectation(description: "Fail to Fetch Music ")
        let testInput = PassthroughSubject<MusicListViewModel.Input, Never>()
        
        // when
        sut.transform(input: testInput.eraseToAnyPublisher())
            .sink { output in
                switch output {
                    // then
                case .fetchMusicListDidFail(let error):
                    XCTAssertEqual(error as NSError, expectedError)
                    expectation.fulfill()
                default:
                    break
                }
            }
            .store(in: &cancellables)
        
        testInput.send(.searchTriggered("test"))
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    // MARK: Mock Music UseCase
    class MockGetMusicListUseCase: GetMusicListUseCaseProtocol {
        var musicListRepository: any MusicPlayer.MusicListRepositoryProtocol
        var willSuceed: Bool = true
        
        init(musicListRepository: any MusicPlayer.MusicListRepositoryProtocol = MusicListRepository()) {
            self.musicListRepository = musicListRepository
        }
        
        func call(trackName: String) -> AnyPublisher<[MusicPlayer.Music], any Error> {
            if willSuceed {
                return Just(MockEntity.musicList)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            } else {
                let error = NSError(domain: "com.example", code: 404, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch music"])
                return Fail(error: error).eraseToAnyPublisher()
            }
        }
        
        
    }
}
