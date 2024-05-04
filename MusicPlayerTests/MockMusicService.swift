//
//  MockMusicService.swift
//  MusicPlayerTests
//
//  Created by Gregorius Yuristama Nugraha on 5/5/24.
//

import Foundation
import Combine
@testable import MusicPlayer

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
