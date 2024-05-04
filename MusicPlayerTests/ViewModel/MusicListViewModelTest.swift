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
    private var repository: MockRepositoryViewModel!
    private var cancellables = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        repository = MockRepositoryViewModel()
        sut = MusicListViewModel(musicListRepository: repository)
    }
    
    override func tearDownWithError() throws {
        try super.setUpWithError()
        repository = nil
        sut = nil
        cancellables.removeAll()
    }
    
    func testFetchMusicSuceed() {
        // given
        let expectedMusicList = MockEntity.musicList
        repository.willSuceed = true
        let expectation = expectation(description: "Music Fethed Succesfully")
        let testInput = PassthroughSubject<MusicListViewModel.Input, Never>()
        
        // when
        sut.transform(input: testInput.eraseToAnyPublisher())
            .sink { output in
                switch output {
                case .fetchMusicListDidSucceed(let musicList):
                    XCTAssertEqual(musicList.count, expectedMusicList.count) // Assuming 3 music items returned from mock repository
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
        repository.willSuceed = false
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
    
    // MARK: Mock Music Repository
    class MockRepositoryViewModel: MusicListRepositoryProtocol {
        var willSuceed: Bool = true
        
        func getMusicListFromTrackName(trackName: String) -> AnyPublisher<[MusicPlayer.Music], any Error> {
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
