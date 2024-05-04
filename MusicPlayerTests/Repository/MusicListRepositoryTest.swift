//
//  MusicListRepositoryTest.swift
//  MusicPlayerTests
//
//  Created by Gregorius Yuristama Nugraha on 5/5/24.
//

import XCTest
import Combine
@testable import MusicPlayer

final class MusicListRepositoryTest: XCTestCase {

    private var sut: MusicListRepository!
    private var mockService: MockMusicService!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockService = MockMusicService()
        sut = MusicListRepository(musicApiService: mockService)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        mockService = nil
        sut = nil
    }
    
    func testFetchMusicSucceed() {
        // given
        mockService.willSucceed = true
        let expectedMusicList = MockEntity.musicList
        let expectation = expectation(description: "Got Music Response")
        
        // when
        let result = sut.getMusicListFromTrackName(trackName: "test")
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
        XCTAssertNil(receivedError)
        XCTAssertEqual(receivedMusic!, expectedMusicList)
        cancellable.cancel()
    }
    
    func testFetchMusicFailed() {
        // given
        mockService.willSucceed = false
        let expectedError = NSError(domain: "com.example", code: 404, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch music"])
        let expectation = expectation(description: "Got No Response")
        
        // when
        let result = sut.getMusicListFromTrackName(trackName: "test")
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
        XCTAssertNotNil(receivedError)
        XCTAssertNil(receivedMusic)
        XCTAssertEqual(receivedError! as NSError, expectedError)
        cancellable.cancel()
    }
    
    class MockMusicService: MusicServiceProtocol {
        var willSucceed: Bool = true
        
        func getMusicListFromTrackName(trackName: String) -> AnyPublisher<MusicPlayer.MusicResponse, any Error> {
            if willSucceed {
                return Just(MockEntity.musicResponse)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            } else {
                let error = NSError(domain: "com.example", code: 404, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch music"])
                return Fail(error: error).eraseToAnyPublisher()
            }
        }
        
        
    }

}
