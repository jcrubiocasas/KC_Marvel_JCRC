//
//  DataStorageManagerTests.swift
//  KC_Marvel_JCRC
//
//  Created by Juan Carlos Rubio Casas on 22/12/24.
//

import XCTest
@testable import KC_Marvel_JCRC
import Combine

@MainActor
final class DataStorageManagerTests: XCTestCase {
    var dataStorageManager: DataStorageManager!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        dataStorageManager = DataStorageManager()
        cancellables = []
    }
    
    override func tearDown() {
        dataStorageManager = nil
        cancellables = nil
        super.tearDown()
    }
    
    // MARK: - Tests for Characters
    
    func testSaveAndGetCharacterSuccess() async throws {
        // Arrange
        let character = Character(
            id: 1,
            name: "Spider-Man",
            description: "Friendly neighborhood hero.",
            thumbnail: CharacterThumbnail(
                path: "https://example.com/spiderman",
                thumbnailExtension: .jpg
            )
        )

        // Save Character
        let saveExpectation = expectation(description: "Save character")
        dataStorageManager.saveCharacter(character)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Save failed with error: \(error)")
                }
                saveExpectation.fulfill()
            }, receiveValue: { })
            .store(in: &cancellables)

        await waitForExpectations(timeout: 15) // Aumentar tiempo de espera

        // Fetch Character
        let fetchExpectation = expectation(description: "Fetch character")
        var characters: [Character] = []
        dataStorageManager.getCharacter(byName: "Spider-Man")
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Fetch failed with error: \(error)")
                }
                fetchExpectation.fulfill()
            }, receiveValue: { fetchedCharacters in
                characters = fetchedCharacters
            })
            .store(in: &cancellables)

        await waitForExpectations(timeout: 10) // Aumentar tiempo de espera
        XCTAssertEqual(characters.first?.name, "Spider-Man", "Character name should match")
    }
    
    // MARK: - Tests for Series
    
    func testSaveAndGetSeriesSuccess() async throws {
        // Arrange
        let series = [
            SerieModel(
                id: 1,
                title: "Amazing Adventures",
                description: "An incredible journey of heroism.",
                thumbnail: SerieThumbnail(
                    path: "https://example.com/series1",
                    thumbnailExtension: "jpg"
                ),
                characterId: 1
            ),
            SerieModel(
                id: 2,
                title: "Heroic Tales",
                description: "Tales of bravery and valor.",
                thumbnail: SerieThumbnail(
                    path: "https://example.com/series2",
                    thumbnailExtension: "jpg"
                ),
                characterId: 1
            )
        ]

        // Save Series
        let saveExpectation = expectation(description: "Save Series")
        dataStorageManager.saveSeries(series)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Save failed with error: \(error.localizedDescription)")
                }
                saveExpectation.fulfill()
            }, receiveValue: { })
            .store(in: &cancellables)

        await waitForExpectations(timeout: 10)

        // Fetch Series
        let fetchExpectation = expectation(description: "Fetch Series")
        var fetchedSeries: [SerieModel] = []
        dataStorageManager.getSeries(for: 1)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Fetch failed with error: \(error.localizedDescription)")
                }
                fetchExpectation.fulfill()
            }, receiveValue: { series in
                fetchedSeries = series
            })
            .store(in: &cancellables)

        await waitForExpectations(timeout: 10)

        // Assert
        debugPrint("Fetched series titles: \(fetchedSeries.map { $0.title })") // Depuración
        XCTAssertEqual(
            fetchedSeries.map { $0.title }.sorted(),
            ["Amazing Adventures", "Heroic Tales"].sorted(),
            "Series titles should match"
        )
    }
    
    // MARK: - Test for Local Storage Deletion
    
    func testDeleteLocalStorage() async throws {
        // Arrange
        let keychainKey = "testKey"
        let character = Character(
            id: 1,
            name: "Spider-Man",
            description: "Friendly neighborhood hero.",
            thumbnail: CharacterThumbnail(
                path: "https://example.com/spiderman",
                thumbnailExtension: .jpg
            )
        )
        let series = SerieModel(
            id: 1,
            title: "Amazing Adventures",
            description: "An incredible journey of heroism.",
            thumbnail: SerieThumbnail(
                path: "https://example.com/series1",
                thumbnailExtension: "jpg"
            ),
            characterId: 1
        )
        
        // Save Character
        let saveCharacterExpectation = expectation(description: "Save character")
        dataStorageManager.saveCharacter(character)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Save character failed with error: \(error)")
                }
                saveCharacterExpectation.fulfill()
            }, receiveValue: { })
            .store(in: &cancellables)
        
        // Save Series
        let saveSeriesExpectation = expectation(description: "Save series")
        dataStorageManager.saveSeries([series])
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Save series failed with error: \(error)")
                }
                saveSeriesExpectation.fulfill()
            }, receiveValue: { })
            .store(in: &cancellables)
        
        await waitForExpectations(timeout: 5)

        // Act - Delete Local Storage
        let deleteSuccess = await dataStorageManager.deleteLocalStorage(keychainKey: keychainKey)

        // Assert - Check deletion success
        XCTAssertTrue(deleteSuccess, "Local storage deletion should succeed")
        
        // Fetch Characters
        let fetchCharactersExpectation = expectation(description: "Fetch characters after deletion")
        var characters: [Character] = []
        dataStorageManager.getCharacter(byName: "Spider-Man")
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Fetching characters failed with error: \(error)")
                }
                fetchCharactersExpectation.fulfill()
            }, receiveValue: { fetchedCharacters in
                characters = fetchedCharacters
            })
            .store(in: &cancellables)
        
        // Fetch Series
        let fetchSeriesExpectation = expectation(description: "Fetch series after deletion")
        var fetchedSeries: [SerieModel] = []
        dataStorageManager.getSeries(for: 1)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Fetching series failed with error: \(error)")
                }
                fetchSeriesExpectation.fulfill()
            }, receiveValue: { series in
                fetchedSeries = series
            })
            .store(in: &cancellables)
        
        await waitForExpectations(timeout: 5)
        
        // Assert - Ensure data is deleted
        XCTAssertTrue(characters.isEmpty, "Character storage should be empty after deletion")
        XCTAssertTrue(fetchedSeries.isEmpty, "Series storage should be empty after deletion")
    }
}
