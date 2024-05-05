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
    private var timeObserver: Any?
    
    lazy var playPauseButton: UIButton = {
        let button = UIButton()
        button.setImage(ButtonImageComponent.pauseButtonImage(), for: .normal)
        button.addTarget(self, action: #selector(playPauseButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setImage(ButtonImageComponent.nextButtonImage(), for: .normal)
        button.addTarget(self, action: #selector(nextButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var prevButton: UIButton = {
        let button = UIButton()
        button.setImage(ButtonImageComponent.previousButtonImage(), for: .normal)
        button.addTarget(self, action: #selector(prevButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var slider: UISlider = {
        let slider = UISlider()
        slider.isContinuous = true
        slider.minimumValue = 0
        slider.maximumValue = 30
        slider.minimumTrackTintColor = .systemGray4
        slider.maximumTrackTintColor = .lightGray
        let thumbImage = UIImage(systemName: ResourcePath.sliderThumbImage)?
            .withTintColor(.white, renderingMode: .alwaysOriginal)
        slider.setThumbImage(thumbImage, for: .normal)
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        return slider
    }()
    
    lazy var songNameLabel: UILabel = {
        let label = UILabel()
        label.text = AppLabel.noSongPlayed
        label.font = FontTheme.semiBoldTheme
        label.numberOfLines = 1
        label.textColor = UIColor.white
        label.textAlignment = .center
        return label
    }()
    
    lazy var artistNameLabel: UILabel = {
        let label = UILabel()
        label.text = AppLabel.noArtistPlayed
        label.font = FontTheme.regularTheme
        label.numberOfLines = 1
        label.textColor = UIColor.white
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        setUpGradientBackground()
        
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
        
        NSLayoutConstraint.activate([
            songNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: Decimal.double16),
            songNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Decimal.double16),
            songNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Decimal.double16),
            
            artistNameLabel.topAnchor.constraint(equalTo: songNameLabel.bottomAnchor, constant: Decimal.double8),
            artistNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            artistNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            slider.topAnchor.constraint(equalTo: artistNameLabel.bottomAnchor, constant: Decimal.double16),
            slider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Decimal.double16),
            slider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Decimal.double16),
            
            playPauseButton.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: Decimal.double16),
            playPauseButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            nextButton.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: Decimal.double16),
            nextButton.leadingAnchor.constraint(equalTo: playPauseButton.trailingAnchor, constant: Decimal.double32),
            
            prevButton.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: Decimal.double16),
            prevButton.trailingAnchor.constraint(equalTo: playPauseButton.leadingAnchor, constant: -Decimal.double32),
        ])
        
        
    }
    
    private func setUpGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        
        let startColor = UIColor(named: ColorPath.startRedGradient)!
        let endColor = UIColor(named: ColorPath.endRedGradient)!
        
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        layer.insertSublayer(gradientLayer, at: 0)
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
            playPauseButton.setImage(ButtonImageComponent.pauseButtonImage(), for: .normal)
        } else {
            AudioPlayerManager.shared.player?.pause()
            playPauseButton.setImage(ButtonImageComponent.playButtonImage(), for: .normal)
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
