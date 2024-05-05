//
//  PlayPauseImage.swift
//  MusicPlayer
//
//  Created by Gregorius Yuristama Nugraha on 5/5/24.
//

import Foundation
import UIKit

/// Helper class for displaying button image from SF Symbols
struct ButtonImageComponent {
    static func playButtonImage() -> UIImage {
        let config = UIImage.SymbolConfiguration(pointSize: Decimal.double32, weight: .bold, scale: .medium)
        return UIImage(systemName: ResourcePath.playImage, withConfiguration: config)!
            .withTintColor(.white, renderingMode: .alwaysOriginal)
    }
    
    static func pauseButtonImage() -> UIImage {
        let config = UIImage.SymbolConfiguration(pointSize: Decimal.double32, weight: .bold, scale: .medium)
        return UIImage(systemName: ResourcePath.pauseImage, withConfiguration: config)!
            .withTintColor(.white, renderingMode: .alwaysOriginal)
    }
    
    static func nextButtonImage() -> UIImage {
        let config = UIImage.SymbolConfiguration(pointSize: Decimal.double32, weight: .bold, scale: .medium)
        return UIImage(systemName: ResourcePath.nextTrackImage, withConfiguration: config)!
            .withTintColor(.white, renderingMode: .alwaysOriginal)
    }
    
    static func previousButtonImage() -> UIImage {
        let config = UIImage.SymbolConfiguration(pointSize: Decimal.double32, weight: .bold, scale: .medium)
        return UIImage(systemName: ResourcePath.previousTrackImage, withConfiguration: config)!
            .withTintColor(.white, renderingMode: .alwaysOriginal)
    }
}
