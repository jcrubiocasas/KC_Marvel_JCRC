//
//  KeyChainKCTests.swift
//  KC_Marvel_JCRC
//
//  Created by Juan Carlos Rubio Casas on 22/12/24.
//
import XCTest
@testable import KC_Marvel_JCRC

final class KeyChainKCTests: XCTestCase {
    
    // MARK: - Pruebas para KeyChainKC usando MockKeyChainKC
    
    func testSaveKeySuccess() {
        // Arrange
        let keychain = MockKeyChainKC()
        let key = "testKey"
        let value = "testValue"
        
        // Act
        let success = keychain.saveKC(key: key, value: value)
        
        // Assert
        XCTAssertTrue(success, "Saving key should return true")
        XCTAssertEqual(keychain.loadKC(key: key), value, "The value for the key should match the saved value")
    }
    
    func testLoadKeySuccess() {
        // Arrange
        let keychain = MockKeyChainKC()
        let key = "testKey"
        let value = "testValue"
        keychain.saveKC(key: key, value: value)
        
        // Act
        let loadedValue = keychain.loadKC(key: key)
        
        // Assert
        XCTAssertEqual(loadedValue, value, "The loaded value should match the saved value")
    }
    
    func testDeleteKeySuccess() {
        // Arrange
        let keychain = MockKeyChainKC()
        let key = "testKey"
        let value = "testValue"
        keychain.saveKC(key: key, value: value)
        
        // Act
        let success = keychain.deleteKC(key: key)
        let loadedValue = keychain.loadKC(key: key)
        
        // Assert
        XCTAssertTrue(success, "Deleting key should return true")
        XCTAssertEqual(loadedValue, "", "The value for the key should be empty after deletion")
    }
    
    func testDeleteNonExistentKey() {
        // Arrange
        let keychain = MockKeyChainKC()
        let key = "nonExistentKey"
        
        // Act
        let success = keychain.deleteKC(key: key)
        
        // Assert
        XCTAssertFalse(success, "Deleting a non-existent key should return false")
    }
    
    func testLoadNonExistentKey() {
        // Arrange
        let keychain = MockKeyChainKC()
        let key = "nonExistentKey"
        
        // Act
        let loadedValue = keychain.loadKC(key: key)
        
        // Assert
        XCTAssertEqual(loadedValue, "", "Loading a non-existent key should return an empty string")
    }
    
    // MARK: - Pruebas usando KeyChainKC real (opcional)
    
    func testSaveAndLoadWithRealKeychain() {
        // Arrange
        let keychain = KeyChainKC()
        let key = "realTestKey"
        let value = "realTestValue"
        
        // Act
        let saveSuccess = keychain.saveKC(key: key, value: value)
        let loadedValue = keychain.loadKC(key: key)
        
        // Assert
        XCTAssertTrue(saveSuccess, "Saving key in real Keychain should return true")
        XCTAssertEqual(loadedValue, value, "The loaded value should match the saved value in real Keychain")
        
        // Cleanup
        _ = keychain.deleteKC(key: key)
    }
    
    func testDeleteKeyInRealKeychain() {
        // Arrange
        let keychain = KeyChainKC()
        let key = "realTestKey"
        let value = "realTestValue"
        keychain.saveKC(key: key, value: value)
        
        // Act
        let deleteSuccess = keychain.deleteKC(key: key)
        let loadedValue = keychain.loadKC(key: key)
        
        // Assert
        XCTAssertTrue(deleteSuccess, "Deleting key in real Keychain should return true")
        XCTAssertEqual(loadedValue, "", "The value for the key should be empty after deletion in real Keychain")
    }
}
