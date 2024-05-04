//
//  MusicPlayerView.swift
//  MusicPlayer
//
//  Created by Gregorius Yuristama Nugraha on 5/4/24.
//

import UIKit
import CoreMedia

class MusicPlayerView: UIView {
    
    var music: Music?
    var audioPlayerDelegate: AudioPlayerDelegate?
    var timeObserver: Any?
    
    lazy var playPauseButton: UIButton = {
        let button = UIButton()
        button.setTitle("Pause", for: .normal)
        button.addTarget(self, action: #selector(playPauseButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("Next", for: .normal)
        button.addTarget(self, action: #selector(nextButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var prevButton: UIButton = {
        let button = UIButton()
        button.setTitle("Previous", for: .normal)
        button.addTarget(self, action: #selector(prevButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var slider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 30
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        return slider
    }()
    
    lazy var songNameLabel: UILabel = {
        let label = UILabel()
        label.text = "No Song Yet"
        label.numberOfLines = 0
        label.textColor = UIColor.white
        label.textAlignment = .center
        return label
    }()
    
    lazy var artistNameLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.numberOfLines = 0
        label.textColor = UIColor.white
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .red
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemNewAccessLogEntry, object: AudioPlayerManager.shared.player?.currentItem)
    }
    
    private func initView() {
        addSubview(playPauseButton)
        addSubview(nextButton)
        addSubview(prevButton)
        addSubview(slider)
        addSubview(songNameLabel)
        addSubview(artistNameLabel)
        
        playPauseButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        prevButton.translatesAutoresizingMaskIntoConstraints = false
        slider.translatesAutoresizingMaskIntoConstraints = false
        songNameLabel.translatesAutoresizingMaskIntoConstraints = false
        artistNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea = self.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            playPauseButton.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            playPauseButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            nextButton.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            nextButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            prevButton.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            prevButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            songNameLabel.bottomAnchor.constraint(equalTo: artistNameLabel.topAnchor, constant: -8),
            songNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            songNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            artistNameLabel.bottomAnchor.constraint(equalTo: slider.topAnchor, constant: -8),
            artistNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            artistNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            
            slider.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -16),
            slider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            slider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
        
        
    }
    
    func songPlayed(music: Music) {
        self.music = music
        
        if let timeObserver = timeObserver {
            AudioPlayerManager.shared.player?.removeTimeObserver(timeObserver)
            self.timeObserver = nil
        }
        
        AudioPlayerManager.shared.play(track: music)
        
        timeObserver = AudioPlayerManager.shared.player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: DispatchQueue.main) { [weak self] time in
            self?.slider.value = Float(time.seconds)
        }
        songNameLabel.text = music.songName
        artistNameLabel.text = music.artistName
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemReadyToPlay), name: .AVPlayerItemNewAccessLogEntry, object: AudioPlayerManager.shared.player?.currentItem)

    }
    
    @objc private func playerItemReadyToPlay() {
        guard let duration = AudioPlayerManager.shared.player?.currentItem?.duration.seconds else { return }
        
        slider.minimumValue = 0
        slider.maximumValue = Float(duration)
    }

    
    @objc func playPauseButtonTapped(_ sender: UIButton) {
        if AudioPlayerManager.shared.player?.rate == 0 {
            AudioPlayerManager.shared.player?.play()
            playPauseButton.setTitle("Pause", for: .normal)
        } else {
            AudioPlayerManager.shared.player?.pause()
            playPauseButton.setTitle("Play", for: .normal)
        }
    }
    
    @objc func nextButtonTapped(_ sender: UIButton) {
        audioPlayerDelegate?.nextTrack()
    }
    
    @objc func prevButtonTapped(_ sender: UIButton) {
        audioPlayerDelegate?.prevTrack()
    }
    
    @objc func sliderValueChanged(_ slider: UISlider) {
        let time = CMTime(seconds: Double(slider.value), preferredTimescale: 1)
        AudioPlayerManager.shared.player?.seek(to: time)
    }
}
