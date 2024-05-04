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
    
    lazy var playingIndicatorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Playing..."
        label.textColor = UIColor.gray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(songNameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.addSubview(playingIndicatorLabel)
        
        NSLayoutConstraint.activate([
            songNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            songNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            songNameLabel.widthAnchor.constraint(equalToConstant: contentView.frame.width - playingIndicatorLabel.frame.width - 20),
            
            artistNameLabel.topAnchor.constraint(equalTo: songNameLabel.bottomAnchor, constant: 4),
            artistNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            artistNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            artistNameLabel.widthAnchor.constraint(equalToConstant: contentView.frame.width - playingIndicatorLabel.frame.width - 20),
            
            playingIndicatorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            playingIndicatorLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
        
        playingIndicatorLabel.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(_ music: Music) {
        songNameLabel.text = music.songName
        artistNameLabel.text = music.artistName
    }
}
