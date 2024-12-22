//
//  HashUseCaseTests.swift
//  KC_Marvel_JCRC
//
//  Created by Juan Carlos Rubio Casas on 22/12/24.
//

import XCTest
@testable import KC_Marvel_JCRC

final class HashUseCaseTests: XCTestCase {
    
    // MARK: - Test de `generateHash`
    
    func testGenerateHash() {
        // Arrange
        let hashUseCase = HashUseCase()
        let ts = "1"
        let apiKeyPublic = "publicKey"
        let apiKeyPrivate = "privateKey"
        
        // Act
        let hash = hashUseCase.generateHash(ts: ts, apiKeyPublic: apiKeyPublic, apiKeyPrivate: apiKeyPrivate)
        
        // Assert
        XCTAssertEqual(hash, hashUseCase.marvelHash(stringToHash: "1privateKeypublicKey"))
    }
    
    func testGenerateHashWithEmptyInputs() {
        // Arrange
        let hashUseCase = HashUseCase()
        let ts = ""
        let apiKeyPublic = ""
        let apiKeyPrivate = ""
        
        // Act
        let hash = hashUseCase.generateHash(ts: ts, apiKeyPublic: apiKeyPublic, apiKeyPrivate: apiKeyPrivate)
        
        // Assert
        XCTAssertEqual(hash, hashUseCase.marvelHash(stringToHash: ""))
    }
    
    // MARK: - Test de `marvelHash`
    
    func testMarvelHash() {
        // Arrange
        let hashUseCase = HashUseCase()
        let input = "1privateKeypublicKey"
        
        // Act
        let hash = hashUseCase.marvelHash(stringToHash: input)
        
        // Assert
        let expectedHash = "233247fdd1aa10ab8d3d2e10e58f9b9d" // Valor calculado con tu implementación
        XCTAssertEqual(hash, expectedHash)
    }
    
    func testMarvelHashWithEmptyString() {
        // Arrange
        let hashUseCase = HashUseCase()
        let input = ""
        
        // Act
        let hash = hashUseCase.marvelHash(stringToHash: input)
        
        // Assert
        let expectedHash = "d41d8cd98f00b204e9800998ecf8427e" // MD5 de una cadena vacía
        XCTAssertEqual(hash, expectedHash)
    }
}
