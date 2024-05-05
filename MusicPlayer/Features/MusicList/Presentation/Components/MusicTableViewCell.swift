//
//  MusicTableViewCell.swift
//  MusicPlayer
//
//  Created by Gregorius Yuristama Nugraha on 5/3/24.
//

import Foundation
import UIKit

class MusicTableViewCell: UITableViewCell {
    static let identifier = "MusicTableViewCell"
    
    let songNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    let artistNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.gray
        return label
    }()
    
    let playOverlayView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.isHidden = true
        return view
    }()
    
    let playOverlayImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: ResourcePath.playIndicatorImage))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .white
        imageView.isHidden = true
        return imageView
    }()
    
    let songImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var isPlaying: Bool = false {
        didSet{
            if isPlaying {
                playOverlayImageView.isHidden = false
                playOverlayView.isHidden = false
            } else {
                playOverlayImageView.isHidden = true
                playOverlayView.isHidden = true
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(songImageView)
        contentView.addSubview(songNameLabel)
        contentView.addSubview(artistNameLabel)
        songImageView.addSubview(playOverlayView)
        playOverlayView.addSubview(playOverlayImageView)
        
        NSLayoutConstraint.activate([
            songImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Decimal.double16),
            songImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            songImageView.widthAnchor.constraint(equalToConstant: Decimal.double40),
            songImageView.heightAnchor.constraint(equalToConstant: Decimal.double40),
            
            playOverlayView.leadingAnchor.constraint(equalTo: songImageView.leadingAnchor),
            playOverlayView.trailingAnchor.constraint(equalTo: songImageView.trailingAnchor),
            playOverlayView.topAnchor.constraint(equalTo: songImageView.topAnchor),
            playOverlayView.bottomAnchor.constraint(equalTo: songImageView.bottomAnchor),
            
            playOverlayImageView.centerXAnchor.constraint(equalTo: songImageView.centerXAnchor),
            playOverlayImageView.centerYAnchor.constraint(equalTo: songImageView.centerYAnchor),
            playOverlayImageView.widthAnchor.constraint(equalToConstant: 40),
            playOverlayImageView.heightAnchor.constraint(equalToConstant: 40),
            
            songNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Decimal.double8),
            songNameLabel.leadingAnchor.constraint(equalTo: songImageView.trailingAnchor, constant: Decimal.double8),
            songNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Decimal.double8),
            
            artistNameLabel.topAnchor.constraint(equalTo: songNameLabel.bottomAnchor, constant: Decimal.double4),
            artistNameLabel.leadingAnchor.constraint(equalTo: songImageView.trailingAnchor, constant: Decimal.double8),
            artistNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Decimal.double8),
            artistNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Decimal.double8)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(_ music: Music) {
        songNameLabel.text = music.songName
        artistNameLabel.text = music.artistName
        if let artworkURL = music.songArtwork {
            fetchArtwork(from: artworkURL)
        } else {
            songImageView.image = UIImage(named: "AppIcon")
        }
    }
    
    private func fetchArtwork(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self, let data = data, error == nil else {
                ErrorManager.shared.showError(errorMessage: error!.localizedDescription)
                return
            }
            
            if let image = UIImage(data: data) {
                DispatchQueue.main.async { [weak self] in
                    self?.songImageView.image = image
                }
            }
        }.resume()
    }
}
