//
//  Untitled.swift
//  KC_Marvel_JCRC
//
//  Created by Juan Carlos Rubio Casas on 16/12/24.
//

import XCTest
@testable import KC_Marvel_JCRC // Cambia por el nombre de tu módulo



final class CharacterTests: XCTestCase {
    
    // MARK: - Test de Inicialización
    
    func testCharacterInitialization() {
        // Arrange
        let thumbnail = CharacterThumbnail(
            path: "https://example.com/image",
            thumbnailExtension: .jpg
        )
        let character = Character(
            id: 1011334,
            name: "3-D Man",
            description: "Un personaje ficticio del universo Marvel.",
            thumbnail: thumbnail
        )
        
        // Act & Assert
        XCTAssertEqual(character.id, 1011334)
        XCTAssertEqual(character.name, "3-D Man")
        XCTAssertEqual(character.description, "Un personaje ficticio del universo Marvel.")
        XCTAssertEqual(character.thumbnail, thumbnail)
    }
    
    // MARK: - Test de Conformidad a Hashable y Equatable
    
    func testCharacterHashable() {
        // Arrange
        let thumbnail = CharacterThumbnail(
            path: "https://example.com/image",
            thumbnailExtension: .jpg
        )
        let character1 = Character(
            id: 1011334,
            name: "3-D Man",
            description: "Un personaje ficticio del universo Marvel.",
            thumbnail: thumbnail
        )
        let character2 = Character(
            id: 1011334,
            name: "3-D Man",
            description: "Otro personaje",
            thumbnail: thumbnail
        )
        
        // Act & Assert
        XCTAssertEqual(character1, character2)
        XCTAssertEqual(character1.hashValue, character2.hashValue)
    }
    
    func testCharacterEquatable() {
        // Arrange
        let thumbnail1 = CharacterThumbnail(
            path: "https://example.com/image",
            thumbnailExtension: .jpg
        )
        let thumbnail2 = CharacterThumbnail(
            path: "https://example.com/other-image",
            thumbnailExtension: .gif
        )
        let character1 = Character(
            id: 1011334,
            name: "3-D Man",
            description: "Un personaje ficticio del universo Marvel.",
            thumbnail: thumbnail1
        )
        let character2 = Character(
            id: 1011335,
            name: "Other Character",
            description: "Otro personaje ficticio.",
            thumbnail: thumbnail2
        )
        
        // Act & Assert
        XCTAssertNotEqual(character1, character2)
    }
    
    // MARK: - Test de Decodificación
    
    func testCharacterDecoding() throws {
        // Arrange
        let jsonData = """
        {
            "id": 1011334,
            "name": "3-D Man",
            "description": "Un personaje ficticio del universo Marvel.",
            "thumbnail": {
                "path": "https://example.com/image",
                "extension": "jpg"
            }
        }
        """.data(using: .utf8)!
        
        // Act
        let character = try JSONDecoder().decode(Character.self, from: jsonData)
        
        // Assert
        XCTAssertEqual(character.id, 1011334)
        XCTAssertEqual(character.name, "3-D Man")
        XCTAssertEqual(character.description, "Un personaje ficticio del universo Marvel.")
        XCTAssertEqual(character.thumbnail.path, "https://example.com/image")
        XCTAssertEqual(character.thumbnail.thumbnailExtension, .jpg)
    }
    
    func testCharacterResultsDecoding() throws {
        // Arrange
        let jsonData = """
        {
            "data": {
                "results": [
                    {
                        "id": 1011334,
                        "name": "3-D Man",
                        "description": "Un personaje ficticio del universo Marvel.",
                        "thumbnail": {
                            "path": "https://example.com/image",
                            "extension": "jpg"
                        }
                    },
                    {
                        "id": 1011335,
                        "name": "Spider-Man",
                        "description": "El hombre araña.",
                        "thumbnail": {
                            "path": "https://example.com/spiderman",
                            "extension": "gif"
                        }
                    }
                ]
            }
        }
        """.data(using: .utf8)!
        
        // Act
        let characterResults = try JSONDecoder().decode(CharacterResults.self, from: jsonData)
        
        // Assert
        XCTAssertEqual(characterResults.characters.count, 2)
        XCTAssertEqual(characterResults.characters[0].name, "3-D Man")
        XCTAssertEqual(characterResults.characters[1].name, "Spider-Man")
    }
    
    
}
