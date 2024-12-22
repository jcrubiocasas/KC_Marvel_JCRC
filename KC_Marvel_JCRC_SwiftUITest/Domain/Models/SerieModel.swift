//
//  SerieModel.swift
//  KC_Marvel_JCRC
//
//  Created by Juan Carlos Rubio Casas on 22/12/24.
//

import XCTest
@testable import KC_Marvel_JCRC

final class SerieModelTests: XCTestCase {
    
    // MARK: - Test de Inicialización
    
    func testSerieModelInitialization() {
        // Arrange
        let thumbnail = SerieThumbnail(
            path: "https://example.com/image",
            thumbnailExtension: "jpg"
        )
        let serie = SerieModel(
            id: 12345,
            title: "Amazing Spider-Man",
            description: "An incredible journey of Spider-Man.",
            thumbnail: thumbnail,
            characterId: 1011334
        )
        
        // Act & Assert
        XCTAssertEqual(serie.id, 12345)
        XCTAssertEqual(serie.title, "Amazing Spider-Man")
        XCTAssertEqual(serie.description, "An incredible journey of Spider-Man.")
        XCTAssertEqual(serie.thumbnail, thumbnail)
        XCTAssertEqual(serie.characterId, 1011334)
    }
    
    // MARK: - Test de Conformidad a Hashable y Equatable
    
    func testSerieModelHashable() {
        // Arrange
        let thumbnail = SerieThumbnail(
            path: "https://example.com/image",
            thumbnailExtension: "jpg"
        )
        let serie1 = SerieModel(
            id: 12345,
            title: "Amazing Spider-Man",
            description: "An incredible journey of Spider-Man.",
            thumbnail: thumbnail,
            characterId: 1011334
        )
        let serie2 = SerieModel(
            id: 12345,
            title: "Amazing Spider-Man",
            description: "Another description",
            thumbnail: thumbnail,
            characterId: 1011334
        )
        
        // Act & Assert
        XCTAssertEqual(serie1, serie2)
        XCTAssertEqual(serie1.hashValue, serie2.hashValue)
    }
    
    func testSerieModelEquatable() {
        // Arrange
        let thumbnail1 = SerieThumbnail(
            path: "https://example.com/image1",
            thumbnailExtension: "jpg"
        )
        let thumbnail2 = SerieThumbnail(
            path: "https://example.com/image2",
            thumbnailExtension: "gif"
        )
        let serie1 = SerieModel(
            id: 12345,
            title: "Amazing Spider-Man",
            description: "An incredible journey of Spider-Man.",
            thumbnail: thumbnail1,
            characterId: 1011334
        )
        let serie2 = SerieModel(
            id: 12346,
            title: "Fantastic Four",
            description: "A story of the Fantastic Four.",
            thumbnail: thumbnail2,
            characterId: 1011335
        )
        
        // Act & Assert
        XCTAssertNotEqual(serie1, serie2)
    }
    
    // MARK: - Test de Decodificación
    
    func testSerieModelDecoding() throws {
        // Arrange
        let jsonData = """
        {
            "id": 12345,
            "title": "Amazing Spider-Man",
            "description": "An incredible journey of Spider-Man.",
            "thumbnail": {
                "path": "https://example.com/image",
                "extension": "jpg"
            },
            "characterId": 1011334
        }
        """.data(using: .utf8)!
        
        // Act
        let serie = try JSONDecoder().decode(SerieModel.self, from: jsonData)
        
        // Assert
        XCTAssertEqual(serie.id, 12345)
        XCTAssertEqual(serie.title, "Amazing Spider-Man")
        XCTAssertEqual(serie.description, "An incredible journey of Spider-Man.")
        XCTAssertEqual(serie.thumbnail.path, "https://example.com/image")
        XCTAssertEqual(serie.thumbnail.thumbnailExtension, "jpg")
        XCTAssertEqual(serie.characterId, 1011334)
    }
    
    func testSerieResultsDecoding() throws {
        // Arrange
        let jsonData = """
        {
            "data": {
                "results": [
                    {
                        "id": 12345,
                        "title": "Amazing Spider-Man",
                        "description": "An incredible journey of Spider-Man.",
                        "thumbnail": {
                            "path": "https://example.com/image",
                            "extension": "jpg"
                        },
                        "characterId": 1011334
                    },
                    {
                        "id": 12346,
                        "title": "Fantastic Four",
                        "description": "A story of the Fantastic Four.",
                        "thumbnail": {
                            "path": "https://example.com/fantastic-four",
                            "extension": "gif"
                        },
                        "characterId": 1011335
                    }
                ]
            }
        }
        """.data(using: .utf8)!
        
        // Act
        let results = try JSONDecoder().decode(SerieResults.self, from: jsonData)
        
        // Assert
        XCTAssertEqual(results.series.count, 2)
        XCTAssertEqual(results.series[0].title, "Amazing Spider-Man")
        XCTAssertEqual(results.series[1].title, "Fantastic Four")
    }
}
