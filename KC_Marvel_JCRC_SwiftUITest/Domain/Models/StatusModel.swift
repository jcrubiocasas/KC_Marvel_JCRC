//
//  StatusModel.swift
//  KC_Marvel_JCRC
//
//  Created by Juan Carlos Rubio Casas on 22/12/24.
//

import XCTest
@testable import KC_Marvel_JCRC

final class AppStateTests: XCTestCase {
    
    // MARK: - Test de Estados Básicos
    
    func testAppStateEqualityBasicCases() {
        XCTAssertEqual(AppState.none, AppState.none)
        XCTAssertEqual(AppState.loadingCharacters, AppState.loadingCharacters)
        XCTAssertEqual(AppState.loadedCharacters, AppState.loadedCharacters)
        XCTAssertNotEqual(AppState.none, AppState.loadingCharacters)
    }
    
    // MARK: - Test de Estados con Personajes
    
    func testAppStateEqualityWithCharacters() {
        // Arrange
        let character1 = Character(
            id: 1,
            name: "Spider-Man",
            description: "Friendly neighborhood Spider-Man.",
            thumbnail: CharacterThumbnail(
                path: "https://example.com/spiderman",
                thumbnailExtension: .jpg
            )
        )
        let character2 = Character(
            id: 2,
            name: "Iron Man",
            description: "Genius, billionaire, playboy, philanthropist.",
            thumbnail: CharacterThumbnail(
                path: "https://example.com/ironman",
                thumbnailExtension: .jpg
            )
        )
        
        // Act & Assert
        XCTAssertEqual(AppState.loadingSeries(character1), AppState.loadingSeries(character1))
        XCTAssertNotEqual(AppState.loadingSeries(character1), AppState.loadingSeries(character2))
        XCTAssertEqual(AppState.loadedSeries(character1), AppState.loadedSeries(character1))
        XCTAssertNotEqual(AppState.loadedSeries(character1), AppState.loadedSeries(character2))
    }
    
    // MARK: - Test de Estados con Series
    
    func testAppStateEqualityWithSeries() {
        // Arrange
        let serie1 = SerieModel(
            id: 1,
            title: "Amazing Spider-Man",
            description: "An incredible journey of Spider-Man.",
            thumbnail: SerieThumbnail(
                path: "https://example.com/image",
                thumbnailExtension: "jpg"
            ),
            characterId: 101
        )
        let serie2 = SerieModel(
            id: 2,
            title: "Iron Man Adventures",
            description: "A journey through the life of Iron Man.",
            thumbnail: SerieThumbnail(
                path: "https://example.com/ironman",
                thumbnailExtension: "jpg"
            ),
            characterId: 102
        )
        
        // Act & Assert
        XCTAssertEqual(AppState.loadingSerieDetail(serie1), AppState.loadingSerieDetail(serie1))
        XCTAssertNotEqual(AppState.loadingSerieDetail(serie1), AppState.loadingSerieDetail(serie2))
        XCTAssertEqual(AppState.loadedSerieDetail(serie1), AppState.loadedSerieDetail(serie1))
        XCTAssertNotEqual(AppState.loadedSerieDetail(serie1), AppState.loadedSerieDetail(serie2))
    }
    
    // MARK: - Test de Estados con Errores
    
    func testAppStateEqualityWithError() {
        XCTAssertEqual(AppState.error("Error 404"), AppState.error("Error 404"))
        XCTAssertNotEqual(AppState.error("Error 404"), AppState.error("Error 500"))
    }
}
