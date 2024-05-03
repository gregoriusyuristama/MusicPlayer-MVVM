//
//  MusicAPIService.swift
//  MusicPlayer
//
//  Created by Gregorius Yuristama Nugraha on 5/3/24.
//

import Foundation
import Combine

protocol ItunesServiceProtocol {
    func getMusicListFromArtistName(artistName: String) -> AnyPublisher<MusicResponse, Error>
}

class ItunesService: ItunesServiceProtocol {
    func getMusicListFromArtistName(artistName: String) -> AnyPublisher<MusicResponse, any Error> {
        let url = URL(string: "https://itunes.apple.com/search?term=\(artistName)")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .catch { error in
                return Fail(error: error).eraseToAnyPublisher()
            }
            .map({ $0.data })
            .decode(type: MusicResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    
}