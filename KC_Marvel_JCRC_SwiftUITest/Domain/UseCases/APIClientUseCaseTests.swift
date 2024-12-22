//
//  APIClientUseCaseTests.swift
//  KC_Marvel_JCRC
//
//  Created by Juan Carlos Rubio Casas on 22/12/24.
//

import XCTest
import Foundation
@testable import KC_Marvel_JCRC

final class APIClientRepositoryFakeSuccessUseCase: APIClientRepositoryProtocol {
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol = APIClientFakeSuccess()) {
        self.apiClient = apiClient
    }
    
    func getCharacter(by characterName: String, apiRouter: APIRouter) async throws -> Character {
        try await apiClient.getCharacter(by: characterName, apiRouter: apiRouter)
    }
    
    func getSeries(by characterId: Int, apiRouter: APIRouter) async throws -> Series {
        try await apiClient.getSeries(by: characterId, apiRouter: apiRouter)
    }
}

final class APIClientRepositoryFakeErrorUseCase: APIClientRepositoryProtocol {
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol = APIClientFakeError()) {
        self.apiClient = apiClient
    }
    
    func getCharacter(by characterName: String, apiRouter: APIRouter) async throws -> Character {
        try await apiClient.getCharacter(by: characterName, apiRouter: apiRouter)
    }
    
    func getSeries(by characterId: Int, apiRouter: APIRouter) async throws -> Series {
        try await apiClient.getSeries(by: characterId, apiRouter: apiRouter)
    }
}

final class APIClientUseCaseTests: XCTestCase {
    
    // MARK: - Test de Éxito: getCharacter
    
    func testGetCharacterSuccess() async throws {
        // Arrange
        let fakeRepository = APIClientRepositoryFakeSuccessUseCase()
        let useCase = APIClientUseCase(repository: fakeRepository)
        let characterName = "Spider-Man"
        
        // Act
        let character = try await useCase.getCharacter(by: characterName, apiRouter: .getCharacter)
        
        // Assert
        XCTAssertEqual(character.name, "Spider-Man")
        XCTAssertEqual(character.description, "Friendly neighborhood Spider-Man.")
        XCTAssertEqual(character.thumbnail.path, "https://example.com/spiderman")
        XCTAssertEqual(character.thumbnail.thumbnailExtension, .jpg)
    }
    
    // MARK: - Test de Éxito: getSeries
    
    func testGetSeriesSuccess() async throws {
        // Arrange
        let fakeRepository = APIClientRepositoryFakeSuccessUseCase()
        let useCase = APIClientUseCase(repository: fakeRepository)
        let characterId = 1011334
        
        // Act
        let series = try await useCase.getSeries(by: characterId, apiRouter: .getSeries(characterId: characterId))
        
        // Assert
        XCTAssertEqual(series.count, 2)
        XCTAssertEqual(series[0].title, "Amazing Spider-Man")
        XCTAssertEqual(series[0].thumbnail.path, "https://example.com/image1")
        XCTAssertEqual(series[1].title, "Iron Man Adventures")
        XCTAssertEqual(series[1].thumbnail.path, "https://example.com/image2")
    }
    
    // MARK: - Test de Error: getCharacter
    
    func testGetCharacterError() async throws {
        // Arrange
        let fakeRepository = APIClientRepositoryFakeErrorUseCase()
        let useCase = APIClientUseCase(repository: fakeRepository)
        let characterName = "NonExistentCharacter"
        
        // Act & Assert
        do {
            _ = try await useCase.getCharacter(by: characterName, apiRouter: .getCharacter)
            XCTFail("Expected error but got a result.")
        } catch {
            XCTAssertEqual(error as? APIError, APIError.noData)
        }
    }
    
    // MARK: - Test de Error: getSeries
    
    func testGetSeriesError() async throws {
        // Arrange
        let fakeRepository = APIClientRepositoryFakeErrorUseCase()
        let useCase = APIClientUseCase(repository: fakeRepository)
        let characterId = 99999
        
        // Act & Assert
        do {
            _ = try await useCase.getSeries(by: characterId, apiRouter: .getSeries(characterId: characterId))
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


final class APIClientFakeSuccess: APIClientProtocol {
    func getCharacter(by characterName: String, apiRouter: APIRouter) async throws -> Character {
        return Character(
            id: 1011334,
            name: "Spider-Man",
            description: "Friendly neighborhood Spider-Man.",
            thumbnail: CharacterThumbnail(
                path: "https://example.com/spiderman",
                thumbnailExtension: .jpg
            )
        )
    }
    
    func getSeries(by characterId: Int, apiRouter: APIRouter) async throws -> Series {
        return [
            SerieModel(
                id: 1,
                title: "Amazing Spider-Man",
                description: "An incredible journey of Spider-Man.",
                thumbnail: SerieThumbnail(
                    path: "https://example.com/image1",
                    thumbnailExtension: "jpg"
                ),
                characterId: characterId
            ),
            SerieModel(
                id: 2,
                title: "Iron Man Adventures",
                description: "A journey through the life of Iron Man.",
                thumbnail: SerieThumbnail(
                    path: "https://example.com/image2",
                    thumbnailExtension: "jpg"
                ),
                characterId: characterId
            )
        ]
    }
}
