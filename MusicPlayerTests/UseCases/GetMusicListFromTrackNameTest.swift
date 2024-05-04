//
//  GetMusicFromTrackNameTest.swift
//  MusicPlayerTests
//
//  Created by Gregorius Yuristama Nugraha on 5/5/24.
//

import XCTest
import Combine
@testable import MusicPlayer

final class GetMusicListFromTrackNameTest: XCTestCase {

    private var sut: GetMusicListFromNameUseCase!
    private var mockRepository: MockMusicListRepository!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockRepository = MockMusicListRepository()
        sut = GetMusicListFromNameUseCase(musicListRepository: mockRepository)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        mockRepository = nil
        sut = nil
    }
    
    func testGetMusicListSucceed() {
        // given
        mockRepository.willSucceed = true
        let expectedMusicList = MockEntity.musicList
        let expectation = expectation(description: "Music List Fetched Successfully")
        
        // when
        let result = sut.call(trackName: "test")
            .eraseToAnyPublisher()
        
        // then
        var receivedMusic: [Music]?
        var receivedError: Error?
        let cancellable = result.sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                receivedError = error
            }
            expectation.fulfill()
        }, receiveValue: { musicList in
            
            receivedMusic = musicList
        })
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(receivedMusic)
        XCTAssertEqual(receivedMusic!, expectedMusicList)
        XCTAssertNil(receivedError)
        cancellable.cancel()
    }
    
    func testGetMusicListFailed() {
        // given
        mockRepository.willSucceed = false
        let expectedError = NSError(domain: "com.example", code: 404, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch music"])
        let expectation = expectation(description: "Music List Fetched with Error")
        
        // when
        let result = sut.call(trackName: "test")
            .eraseToAnyPublisher()
        
        // then
        var receivedMusic: [Music]?
        var receivedError: Error?
        let cancellable = result.sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                receivedError = error
            }
            expectation.fulfill()
        }, receiveValue: { musicList in
            
            receivedMusic = musicList
        })
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNil(receivedMusic)
        XCTAssertNotNil(receivedError)
        XCTAssertEqual(expectedError, receivedError! as NSError)
        cancellable.cancel()
    }

    // MARK: Mock Repository
    class MockMusicListRepository: MusicListRepositoryProtocol {
        var willSucceed: Bool = true
        
        func getMusicListFromTrackName(trackName: String) -> AnyPublisher<[MusicPlayer.Music], any Error> {
            if willSucceed {
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
