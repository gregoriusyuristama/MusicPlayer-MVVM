import Foundation
import AVFoundation
import Combine

class AudioPlayerManager {
    static let shared = AudioPlayerManager()
    
    var player: AVPlayer?
    private var playerItem: AVPlayerItem?
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        player = AVPlayer()
    }
    
    func play(track: Music) {
        guard let audioUrl = track.audioUrl else { return }
        // Create the asset to play
        let asset = AVAsset(url: audioUrl)
        
        // Create a new AVPlayerItem with the asset and an
        // array of asset keys to be automatically loaded
        playerItem = AVPlayerItem(asset: asset)
        
        // Associate the player item with the player
        player = AVPlayer(playerItem: playerItem)
        player?.replaceCurrentItem(with: playerItem)
        print("Now playing: \(track.songName)")
        player?.play()
        
        // Subscribe to AVPlayer status changes
        playerItem?.publisher(for: \.status)
            .sink { [weak self] status in
                switch status {
                case .readyToPlay:
                    // Player item is ready to play.
                    print("Ready To Play")
                case .failed:
                    // Player item failed. See error.
                    self?.handleErrorWithMessage(self?.player?.currentItem?.error?.localizedDescription, error: self?.player?.currentItem?.error)
                case .unknown:
                    // Player item is not yet ready.
                    print("Player Not Yet Ready")
                @unknown default:
                    print("Unknown Error")
                }
            }
            .store(in: &cancellables)
    }
    
    func pause() {
        player?.pause()
        print("Playback paused")
    }
    
    private func handleErrorWithMessage(_ message: String?, error: Error? = nil) {
        ErrorManager.shared.showError(errorMessage: error?.localizedDescription ?? "Unknown Error")
    }
}
