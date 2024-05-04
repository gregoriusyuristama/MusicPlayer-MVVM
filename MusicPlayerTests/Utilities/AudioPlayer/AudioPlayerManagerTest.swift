//
//  AudioPlayerManagerTest.swift
//  MusicPlayerTests
//
//  Created by Gregorius Yuristama Nugraha on 5/5/24.
//

import XCTest
import AVFoundation
@testable import MusicPlayer

class AudioPlayerManagerTest: XCTestCase {
    
    private var sut: AudioPlayerManager!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = AudioPlayerManager.shared
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    func testPlayTrack() {
        // given
        let testMusic = MockEntity.singleMusic
        let expectation = XCTestExpectation(description: "AVPlayerItem status is ready")

        // when
        sut.play(track: testMusic)

        // Set up observation for AVPlayerItem status
        let observation = sut.player?.currentItem?.observe(\.status) { (playerItem, _) in
            if playerItem.status == .readyToPlay {
                expectation.fulfill()
            }
        }
        // then
        XCTAssertEqual(sut.player?.timeControlStatus.rawValue, 1)
        // Wait for the expectation
        wait(for: [expectation], timeout: 5.0)
        

        // Clean up observation
        observation?.invalidate()
    }
    
    func testPauseTrack() {
        // given
        let testMusic = MockEntity.singleMusic
        let expectation = XCTestExpectation(description: "AVPlayerItem status is ready")

        // when
        sut.play(track: testMusic)

        // Set up observation for AVPlayerItem status
        let observation = sut.player?.currentItem?.observe(\.status) { (playerItem, _) in
            if playerItem.status == .readyToPlay {
                expectation.fulfill()
            }
        }
        // then
        // Wait for the expectation
        wait(for: [expectation], timeout: 5.0)
        sut.pause()
        XCTAssertEqual(sut.player?.timeControlStatus.rawValue, 0)

        // Clean up observation
        observation?.invalidate()
        
    }
}
