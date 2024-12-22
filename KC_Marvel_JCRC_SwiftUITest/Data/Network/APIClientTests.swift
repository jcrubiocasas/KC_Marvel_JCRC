//
//  Untitled.swift
//  KC_Marvel_JCRC
//
//  Created by Juan Carlos Rubio Casas on 22/12/24.
//

import XCTest
@testable import KC_Marvel_JCRC

final class NetworkAPIClientFakeSuccess: APIClientProtocol {
    func getCharacter(by characterName: String, apiRouter: APIRouter) async throws -> Character {
        return Character(
            id: 1011334,
            name: characterName,
            description: "Friendly neighborhood \(characterName).",
            thumbnail: CharacterThumbnail(
                path: "https://example.com/\(characterName.lowercased())",
                thumbnailExtension: .jpg
            )
        )
    }
    
    func getSeries(by characterId: Int, apiRouter: APIRouter) async throws -> Series {
        // Simulación de series omitida para este caso
        return []
    }
}

final class NetworkAPIClientFakeError: APIClientProtocol {
    func getCharacter(by characterName: String, apiRouter: APIRouter) async throws -> Character {
        throw APIClient.APIError.noData
    }
    
    func getSeries(by characterId: Int, apiRouter: APIRouter) async throws -> Series {
        throw APIClient.APIError.statusCode(code: 404) // Simula un error 404
    }
}

final class NetworkAPIClientTests: XCTestCase {
    
    // MARK: - Test de Éxito: getCharacter
    
    func testGetCharacterSuccess() async throws {
        // Arrange
        let apiClient = NetworkAPIClientFakeSuccess()
        let characterName = "Spider-Man"
        
        // Act
        let character = try await apiClient.getCharacter(by: characterName, apiRouter: .getCharacter)
        
        // Assert
        XCTAssertFalse(character.name.isEmpty, "Character name should not be empty")
        XCTAssertEqual(character.description, "Friendly neighborhood \(characterName).")
        XCTAssertTrue(character.thumbnail.path.contains(characterName.lowercased()), "Thumbnail path should contain the character name in lowercase")
        XCTAssertEqual(character.thumbnail.thumbnailExtension, .jpg)
    }
    
    // MARK: - Test de Éxito: getSeries
    
    func testGetSeriesSuccess() async throws {
        // Arrange
        let apiClient = NetworkAPIClientFakeSuccess()
        let characterId = 1011334
        
        // Act
        let series = try await apiClient.getSeries(by: characterId, apiRouter: .getSeries(characterId: characterId))
        
        // Assert
        XCTAssertEqual(series.count, 0, "Series count should be 0 when no series are simulated")
    }
    
    // MARK: - Test de Error: getCharacter
    
    func testGetCharacterError() async throws {
        // Arrange
        let apiClient = APIClient()
        let invalidRouter = APIRouter.getCharacter
        let characterName = "" // Forzamos un valor inválido
        
        // Act & Assert
        do {
            _ = try await apiClient.getCharacter(by: characterName, apiRouter: invalidRouter)
            XCTFail("Expected error but got a result.")
        } catch {
            guard let apiError = error as? APIClient.APIError else {
                XCTFail("Expected APIError but got \(error)")
                return
            }
            
            // Aseguramos que se produce un error de statusCode con 409
            XCTAssertEqual(apiError, .statusCode(code: 409), "Expected statusCode error with 409")
        }
    }
    
    // MARK: - Test de Error: getSeries
    
    func testGetSeriesError() async throws {
        // Arrange
        let apiClient = NetworkAPIClientFakeError()
        let invalidRouter = APIRouter.getSeries(characterId: -1)
        let characterId = -1 // ID inválido
        
        // Act & Assert
        do {
            _ = try await apiClient.getSeries(by: characterId, apiRouter: invalidRouter)
            XCTFail("Expected error but got a result.")
        } catch {
            guard let apiError = error as? APIClient.APIError else {
                XCTFail("Expected APIError but got \(error)")
                return
            }
            
            // Aseguramos que se produce un error de código de estado
            XCTAssertEqual(apiError, .statusCode(code: 404), "Expected statusCode error with 404")
        }
    }
}
