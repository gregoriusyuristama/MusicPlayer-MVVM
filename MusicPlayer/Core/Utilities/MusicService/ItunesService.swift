//
//  MusicAPIService.swift
//  MusicPlayer
//
//  Created by Gregorius Yuristama Nugraha on 5/3/24.
//

import Foundation
import Combine

protocol MusicServiceProtocol {
    func getMusicListFromTrackName(trackName: String) -> AnyPublisher<MusicResponse, Error>
}

class ItunesService: MusicServiceProtocol {
    func getMusicListFromTrackName(trackName: String) -> AnyPublisher<MusicResponse, any Error> {
        let url = URL(string: "https://itunes.apple.com/search?term=\(trackName)")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .catch { error in
                return Fail(error: error).eraseToAnyPublisher()
            }
            .map({ $0.data })
            .decode(type: MusicResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    
}
