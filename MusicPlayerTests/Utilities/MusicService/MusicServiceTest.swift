//
//  MusicServiceTest.swift
//  MusicPlayerTests
//
//  Created by Gregorius Yuristama Nugraha on 5/5/24.
//

import XCTest
@testable import MusicPlayer

final class MusicServiceTest: XCTestCase {
    
    private var sut: MockMusicService!

    override func setUpWithError() throws {
       try super.setUpWithError()
        sut = MockMusicService()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    func testHitMusicServiceSucceed() {
        // given
        sut.willSucceed = true
        let expectedResponse = MockEntity.musicResponse
        let expectation = expectation(description: "Got Music Response")
        
        // when
        let result = sut.getMusicListFromTrackName(trackName: "test")
            .eraseToAnyPublisher()
        
        // then
        var receivedResponse: MusicResponse?
        var receivedError: Error?
        let cancellable = result.sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                receivedError = error
            }
            expectation.fulfill()
        } receiveValue: { musicResponse in
            receivedResponse = musicResponse
        }
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(receivedResponse)
        XCTAssertNil(receivedError)
        XCTAssertEqual(receivedResponse!.results.count, expectedResponse.results.count)
        cancellable.cancel()

    }
    
    func testHitMusicServiceFailed() {
        // given
        sut.willSucceed = false
        let expectedError = NSError(domain: "com.example", code: 404, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch music"])
        let expectation = expectation(description: "Got No Music Response")
        
        // when
        let result = sut.getMusicListFromTrackName(trackName: "test")
            .eraseToAnyPublisher()
        
        // then
        var receivedResponse: MusicResponse?
        var receivedError: Error?
        let cancellable = result.sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                receivedError = error
            }
            expectation.fulfill()
        } receiveValue: { musicResponse in
            receivedResponse = musicResponse
        }
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(receivedError)
        XCTAssertNil(receivedResponse)
        XCTAssertEqual(receivedError! as NSError, expectedError)
        cancellable.cancel()

    }

}
