//
//  AudioPlayerManager.swift
//  MusicPlayer
//
//  Created by Gregorius Yuristama Nugraha on 5/3/24.
//

import Foundation
import AVFoundation

class AudioPlayerManager {
    static let shared = AudioPlayerManager()
    
    var player: AVPlayer?
    var tracks: [Music] = []
    var currentTrackIndex: Int = 0
    
    private init() {
        player = AVPlayer()
    }
    
    private func play() {
        guard let player = player, let currentTrack = currentTrack else { return }
        player.play()
        print("Now playing: \(currentTrack.songName)")
    }
    
    func pause() {
        player?.pause()
        print("Playback paused")
    }
    
    func playNext() {
        guard tracks.indices.contains(currentTrackIndex + 1) else { return }
        currentTrackIndex += 1
        playCurrentTrack()
    }
    
    func playPrevious() {
        guard tracks.indices.contains(currentTrackIndex - 1) else { return }
        currentTrackIndex -= 1
        playCurrentTrack()
    }
    
    func playCurrentTrack() {
        guard let player = player, let trackURL = tracks[currentTrackIndex].audioUrl else { return }
        let playerItem = AVPlayerItem(url: trackURL)
        
        player.replaceCurrentItem(with: playerItem)
        play()
    }
    
    private var currentTrack: Music? {
        guard !tracks.isEmpty && tracks.indices.contains(currentTrackIndex) else { return nil }
        return tracks[currentTrackIndex]
    }
}

