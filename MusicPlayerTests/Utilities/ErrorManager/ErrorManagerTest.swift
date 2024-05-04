//
//  ErrorManagerTest.swift
//  MusicPlayerTests
//
//  Created by Gregorius Yuristama Nugraha on 5/5/24.
//

import XCTest
@testable import MusicPlayer

final class ErrorManagerTest: XCTestCase {
    
    private var sut: ErrorManager!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = ErrorManager.shared
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    func testShowError() {
        // Given
        let testErrorMessage = "Test error message"
        
        // When
        sut.showError(errorMessage: testErrorMessage)
        
        // Then
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let rootViewController = windowScene?.keyWindow?.rootViewController
        XCTAssertTrue(rootViewController?.presentedViewController is UIAlertController)
        
        if let alertController = rootViewController?.presentedViewController as? UIAlertController {
            XCTAssertEqual(alertController.title, "Error")
            XCTAssertEqual(alertController.message, testErrorMessage)
        }
    }
}
