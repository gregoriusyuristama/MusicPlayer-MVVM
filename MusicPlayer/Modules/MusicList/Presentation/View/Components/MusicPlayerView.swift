//
//  MusicPlayerView.swift
//  MusicPlayer
//
//  Created by Gregorius Yuristama Nugraha on 5/4/24.
//

import UIKit
import CoreMedia

class MusicPlayerView: UIView {

    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .red
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        addSubview(playPauseButton)
        addSubview(nextButton)
        addSubview(prevButton)
        addSubview(slider)
        
        playPauseButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        prevButton.translatesAutoresizingMaskIntoConstraints = false
        slider.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            playPauseButton.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            playPauseButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            nextButton.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            nextButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            prevButton.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            prevButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            slider.topAnchor.constraint(equalTo: nextButton.bottomAnchor, constant: 8),
            slider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            slider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
        
        AudioPlayerManager.shared.player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: DispatchQueue.main) { [weak self] time in
            self?.slider.value = Float(time.seconds)
            if AudioPlayerManager.shared.player?.rate == 0 {
                self?.playPauseButton.setTitle("Play", for: .normal)
            } else {
                self?.playPauseButton.setTitle("Pause", for: .normal)
            }
        }
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
        AudioPlayerManager.shared.playNext()
    }
    
    @objc func prevButtonTapped(_ sender: UIButton) {
        AudioPlayerManager.shared.playPrevious()
    }
    
    @objc func sliderValueChanged(_ slider: UISlider) {
        let time = CMTime(seconds: Double(slider.value), preferredTimescale: 1)
        AudioPlayerManager.shared.player?.seek(to: time)
    }
}
