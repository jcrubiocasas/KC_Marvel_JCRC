//
//  DataStorageManager.swift
//  KC_Marvel_JCRC
//
//  Created by Juan Carlos Rubio Casas on 20/12/24.
//

import Foundation
import SwiftData
import Combine

// MARK: - DataStorageProtocol

/// Protocolo que define las operaciones de almacenamiento y recuperación de datos.
protocol DataStorageProtocol {
    func saveCharacter(_ character: Character) async -> AnyPublisher<Void, Error>
    func getCharacter(byName name: String) async -> AnyPublisher<[Character], Error>
    func saveSeries(_ series: [SerieModel]) async -> AnyPublisher<Void, Error>
    func getSeries(for characterId: Int) async -> AnyPublisher<[SerieModel], Error>
}

// MARK: - DataStorageManager

/// Clase responsable del almacenamiento local de datos utilizando `SwiftData`.
@MainActor
class DataStorageManager: DataStorageProtocol {
    
    // MARK: - Properties
    
    /// Contenedor principal para la gestión de entidades persistentes.
    let container: ModelContainer
    
    // MARK: - Initializer
    
    /// Inicializa el gestor de almacenamiento y configura el contenedor.
    init() {
        do {
            container = try ModelContainer(for: CharacterEntity.self, SeriesEntity.self)
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }
    
    // MARK: - Character Operations
    
    /// Guarda un personaje en la base de datos.
    func saveCharacter(_ character: Character) -> AnyPublisher<Void, Error> {
        Future { [weak self] promise in
            guard let self = self else { return }
            let context = self.container.mainContext
            let characterEntity = CharacterEntity(
                id: character.id,
                name: character.name,
                characterDescription: character.description,
                thumbnailPath: character.thumbnail.path,
                thumbnailExtension: character.thumbnail.thumbnailExtension.rawValue
            )
            context.insert(characterEntity)
            self.saveContext(promise: promise)
        }
        .eraseToAnyPublisher()
    }
    
    /// Recupera personajes por nombre desde la base de datos.
    func getCharacter(byName name: String) -> AnyPublisher<[Character], Error> {
        Future { [weak self] promise in
            guard let self = self else { return }
            let context = self.container.mainContext
            let fetchRequest = FetchDescriptor<CharacterEntity>(predicate: #Predicate { $0.name.contains(name) })
            
            do {
                let results = try context.fetch(fetchRequest)
                let characters = results.map { entity in
                    Character(
                        id: entity.id,
                        name: entity.name,
                        description: entity.characterDescription,
                        thumbnail: CharacterThumbnail(
                            path: entity.thumbnailPath,
                            thumbnailExtension: Extension(rawValue: entity.thumbnailExtension) ?? .jpg
                        )
                    )
                }
                promise(.success(characters))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    // MARK: - Series Operations
    
    /// Guarda una lista de series en la base de datos.
    func saveSeries(_ series: [SerieModel]) -> AnyPublisher<Void, Error> {
        Future { [weak self] promise in
            guard let self = self else { return }
            let context = self.container.mainContext
            for serie in series {
                let seriesEntity = SeriesEntity(
                    id: serie.id,
                    title: serie.title,
                    descriptionText: serie.description,
                    thumbnailPath: serie.thumbnail.path,
                    thumbnailExtension: serie.thumbnail.thumbnailExtension,
                    characterId: serie.characterId
                )
                context.insert(seriesEntity)
            }
            do {
                try context.save()
                debugPrint("Saved series successfully")
                promise(.success(()))
            } catch {
                debugPrint("Error saving series: \(error)")
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    /// Recupera series asociadas a un personaje específico.
    func getSeries(for characterId: Int) -> AnyPublisher<[SerieModel], Error> {
        Future { [weak self] promise in
            guard let self = self else { return }
            let context = self.container.mainContext
            let fetchRequest = FetchDescriptor<SeriesEntity>(predicate: #Predicate { $0.characterId == characterId })
            
            do {
                let results = try context.fetch(fetchRequest)
                let sortedResults = results.sorted { $0.id < $1.id }
                debugPrint("Fetched and sorted series: \(sortedResults.map { $0.id })")
                let series = sortedResults.map { entity in
                    SerieModel(
                        id: entity.id,
                        title: entity.title,
                        description: entity.descriptionText,
                        thumbnail: SerieThumbnail(
                            path: entity.thumbnailPath,
                            thumbnailExtension: entity.thumbnailExtension
                        ),
                        characterId: entity.characterId
                    )
                }
                promise(.success(series))
            } catch {
                debugPrint("Fetch error: \(error)")
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    // MARK: - Save Context
    
    /// Guarda los cambios en el contexto.
    private func saveContext(promise: @escaping (Result<Void, Error>) -> Void) {
        let context = container.mainContext
        do {
            try context.save()
            promise(.success(()))
        } catch {
            promise(.failure(error))
        }
    }
}

// MARK: - DataStorageManager (Local Storage)

@MainActor
extension DataStorageManager {
    
    /// Elimina todos los datos almacenados y limpia el Keychain.
    func deleteLocalStorage(keychainKey: String) async -> Bool {
        let keychainDeleted = KeyChainKC().deleteKC(key: keychainKey)
        if !keychainDeleted {
            debugPrint("Error: No se pudo eliminar la clave \(keychainKey) del Keychain.")
        }
        
        do {
            let context = container.mainContext
            let characters = try context.fetch(FetchDescriptor<CharacterEntity>())
            characters.forEach { context.delete($0) }
            let series = try context.fetch(FetchDescriptor<SeriesEntity>())
            series.forEach { context.delete($0) }
            try context.save()
            debugPrint("Base de datos limpia: Se eliminaron todos los datos.")
            return true
        } catch {
            debugPrint("Error al limpiar la base de datos: \(error.localizedDescription)")
            return false
        }
    }
}

// MARK: - DataStorageManager (Fetch Character Details)

extension DataStorageManager {
    
    /// Recupera los detalles de un personaje por su ID.
    func fetchCharacterDetails(by id: Int) async -> Character? {
        await withCheckedContinuation { continuation in
            _ = Future { [weak self] promise in
                guard let self = self else {
                    promise(.failure(NSError(domain: "DataStorageManager", code: 500, userInfo: [NSLocalizedDescriptionKey: "Self is nil."])))
                    return
                }
                let context = self.container.mainContext
                let fetchRequest = FetchDescriptor<CharacterEntity>(predicate: #Predicate { $0.id == id })
                
                do {
                    let results = try context.fetch(fetchRequest)
                    if let entity = results.first {
                        let character = Character(
                            id: entity.id,
                            name: entity.name,
                            description: entity.characterDescription,
                            thumbnail: CharacterThumbnail(
                                path: entity.thumbnailPath,
                                thumbnailExtension: Extension(rawValue: entity.thumbnailExtension) ?? .jpg
                            )
                        )
                        promise(.success(character))
                    } else {
                        promise(.failure(NSError(domain: "DataStorageManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "Character not found."])))
                    }
                } catch {
                    promise(.failure(error as NSError))
                }
            }
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    continuation.resume(returning: nil)
                    debugPrint("Fetch error: \(error.localizedDescription)")
                }
            }, receiveValue: { character in
                continuation.resume(returning: character)
            })
        }
    }
}
