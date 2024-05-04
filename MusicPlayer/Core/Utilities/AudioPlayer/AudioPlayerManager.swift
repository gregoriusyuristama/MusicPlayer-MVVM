//
//  AudioPlayerManager.swift
//  MusicPlayer
//
//  Created by Gregorius Yuristama Nugraha on 5/3/24.
//

import Foundation
import AVFoundation

class AudioPlayerManager: NSObject {
    static let shared = AudioPlayerManager()
    
    var player: AVPlayer?
    private var playerItem: AVPlayerItem?
    
    
    private override init() {
        super.init()
        player = AVPlayer()
    }
    
    deinit {
        playerItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status))
    }
    func play(track: Music) {
        guard let audioUrl = track.audioUrl else { return }
        // Create the asset to play
        let asset = AVAsset(url: audioUrl)
        
        // Create a new AVPlayerItem with the asset and an
        // array of asset keys to be automatically loaded
        playerItem = AVPlayerItem(asset: asset)
        
        // Register as an observer of the player item's status property
        playerItem?.addObserver(self,
                                forKeyPath: #keyPath(AVPlayerItem.status),
                                options: [.old, .new],
                                context: nil)
        
        // Associate the player item with the player
        player = AVPlayer(playerItem: playerItem)
        player?.replaceCurrentItem(with: playerItem)
        print("Now playing: \(track.songName)")
        player?.play()
    }
    
    func pause() {
        player?.pause()
        print("Playback paused")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(AVPlayerItem.status) {
            let status: AVPlayerItem.Status
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayerItem.Status(rawValue: statusNumber.intValue)!
            } else {
                status = .unknown
            }
            
            // Switch over status value
            switch status {
            case .readyToPlay:
                // Player item is ready to play.
                print("Ready To Play")
            case .failed:
                // Player item failed. See error.
                handleErrorWithMessage(player?.currentItem?.error?.localizedDescription, error: player?.currentItem?.error)
            case .unknown:
                // Player item is not yet ready.
                print("Player Not Yet Ready")
            @unknown default:
                print("Unknown Error")
            }
        }
    }
    
    private func handleErrorWithMessage(_ message: String?, error: Error? = nil) {
        ErrorManager.shared.showError(errorMessage: error?.localizedDescription ?? "Unkown Error")
    }
}

// MARK: Testable initializer extension
extension AudioPlayerManager {
    convenience init(playerItem: AVPlayerItem) {
        self.init()
        self.playerItem = playerItem
    }
}
