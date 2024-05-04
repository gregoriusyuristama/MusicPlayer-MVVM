//
//  AudioPlayerErrorHandler.swift
//  MusicPlayer
//
//  Created by Gregorius Yuristama Nugraha on 5/4/24.
//

import Foundation
import UIKit

class ErrorManager {
    static let shared = ErrorManager()
    
    func showError(errorMessage: String) {
        guard let keyWindow = UIApplication.shared.keyWindow else { return }
        
        let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        keyWindow.rootViewController?.present(alertController, animated: true, completion: nil)
    }
}
