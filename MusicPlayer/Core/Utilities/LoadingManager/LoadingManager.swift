//
//  LoadingManager.swift
//  MusicPlayer
//
//  Created by Gregorius Yuristama Nugraha on 5/3/24.
//

import Foundation
import UIKit

class LoadingManager {
    static let shared = LoadingManager()
    
    func showLoading() {
        guard let keyWindow = UIApplication.shared.keyWindow else { return }
        
        let alertController = UIAlertController(title: "Loading...", message: "", preferredStyle: .alert)
        
        keyWindow.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    func hideLoading() {
        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
    }
}
