//
//  APIClientRepositoryTests.swift
//  KC_Marvel_JCRC
//
//  Created by Juan Carlos Rubio Casas on 22/12/24.
//

import XCTest
@testable import KC_Marvel_JCRC

final class DataAPIClientFakeSuccess: APIClientProtocol {
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
        return [
            SerieModel(
                id: 1,
                title: "Amazing \(characterId)",
                description: "Adventures of character \(characterId).",
                thumbnail: SerieThumbnail(
                    path: "https://example.com/series\(characterId)",
                    thumbnailExtension: "jpg"
                ),
                characterId: characterId
            ),
            SerieModel(
                id: 2,
                title: "Fantastic \(characterId)",
                description: "Stories about character \(characterId).",
                thumbnail: SerieThumbnail(
                    path: "https://example.com/fantastic\(characterId)",
                    thumbnailExtension: "jpg"
                ),
                characterId: characterId
            )
        ]
    }
}

final class APIClientFakeError: APIClientProtocol {
    func getCharacter(by characterName: String, apiRouter: APIRouter) async throws -> Character {
        throw APIError.noData
    }
    
    func getSeries(by characterId: Int, apiRouter: APIRouter) async throws -> Series {
        throw APIError.statusCode(code: 404)
    }
}

final class DataAPIClientRepositoryTests: XCTestCase {
    
    // MARK: - Test de Éxito: getCharacter
    
    func testGetCharacterSuccess() async throws {
        // Arrange
        let repository = APIClientRepository(apiClient: DataAPIClientFakeSuccess())
        let characterName = "Spider-Man"
        
        // Act
        let character = try await repository.getCharacter(by: characterName, apiRouter: .getCharacter)
        
        // Assert
        XCTAssertEqual(character.name, "Spider-Man")
        XCTAssertEqual(character.description, "Friendly neighborhood Spider-Man.")
        XCTAssertEqual(character.thumbnail.path, "https://example.com/spider-man")
        XCTAssertEqual(character.thumbnail.thumbnailExtension, .jpg)
    }
    
    // MARK: - Test de Éxito: getSeries
    
    func testGetSeriesSuccess() async throws {
        // Arrange
        let repository = APIClientRepository(apiClient: DataAPIClientFakeSuccess())
        let characterId = 1011334
        
        // Act
        let series = try await repository.getSeries(by: characterId, apiRouter: .getSeries(characterId: characterId))
        
        // Assert
        XCTAssertEqual(series.count, 2)
        XCTAssertEqual(series[0].title, "Amazing 1011334")
        XCTAssertEqual(series[0].thumbnail.path, "https://example.com/series1011334")
        XCTAssertEqual(series[1].title, "Fantastic 1011334")
        XCTAssertEqual(series[1].thumbnail.path, "https://example.com/fantastic1011334")
    }
    
    // MARK: - Test de Error: getCharacter
    
    func testGetCharacterError() async throws {
        // Arrange
        let repository = APIClientRepository(apiClient: APIClientFakeError())
        let characterName = "NonExistentCharacter"
        
        // Act & Assert
        do {
            _ = try await repository.getCharacter(by: characterName, apiRouter: .getCharacter)
            XCTFail("Expected error but got a result.")
        } catch {
            XCTAssertEqual(error as? APIError, APIError.noData)
        }
    }
    
    // MARK: - Test de Error: getSeries
    
    func testGetSeriesError() async throws {
        // Arrange
        let repository = APIClientRepository(apiClient: APIClientFakeError())
        let characterId = 99999
        
        // Act & Assert
        do {
            _ = try await repository.getSeries(by: characterId, apiRouter: .getSeries(characterId: characterId))
            XCTFail("Expected error but got a result.")
        } catch {
            guard case APIError.statusCode(let code) = error else {
                XCTFail("Expected APIError.statusCode but got \(error)")
                return
            }
            XCTAssertEqual(code, 404)
        }
    }
}
