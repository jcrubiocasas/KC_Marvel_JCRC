//
//  CharactersViewModel.swift
//  KC_Marvel_JCRC
//
//  Created by Juan Carlos Rubio Casas on 17/12/24.
//

import Foundation
import Combine
import SwiftUI

// MARK: - CharactersViewModel

/// ViewModel encargado de gestionar la lista de personajes de Marvel.
/// Maneja la carga de datos desde la API y el almacenamiento local.
@MainActor
final class CharactersViewModel: ObservableObject {
    // MARK: - Properties
    
    /// Referencia al estado principal de la aplicación.
    private var appState: RootViewModel
    
    /// Lista de personajes cargados.
    @Published var characters: [Character] = []
    
    /// Caso de uso para interactuar con la API.
    private let apiClientUseCase: APIClientUseCaseProtocol
    
    /// Administrador de almacenamiento de datos.
    private let dataStorageManager: DataStorageManager
    
    /// Conjunto de suscripciones para Combine.
    private var cancellables = Set<AnyCancellable>()
    
    /// Lista predefinida de nombres de personajes que se cargarán.
    private let listCharacters: [String] = [
        "Spider-Man (Peter Parker)", "Wolverine", "Iron Man",
        "Captain America", "Hulk", "Thor", "Deadpool", "Black Panther",
        "Black Widow", "Doctor Strange", "Captain Britain", "Captain Marvel (Carol Danvers)",
        "Hawkeye", "Scarlet Witch", "Vision", "Gamora", "Star-Lord (Peter Quill)",
        "Rocket Raccoon", "Groot", "Drax", "Loki", "Silver Surfer", "Doctor Strange",
        "Daredevil", "Punisher", "Nick Fury", "Professor X", "Magneto", "Charles Xavier",
        "Jean Grey", "Cyclops", "Storm", "Beast", "Mystique", "Colossus",
        "Iceman", "Gambit", "Sabretooth", "Doctor Doom", "Kingpin",
        "Electro", "Sandman", "Rhino", "Mysterio", "Shang-Chi",
        "Blade", "Moon Knight", "Jessica Jones", "Luke Cage"
    ]

    // MARK: - Initializer
    
    /// Inicializa el `CharactersViewModel`.
    /// - Parameters:
    ///   - appState: Estado principal de la aplicación.
    ///   - apiClientUseCase: Caso de uso para interactuar con la API (por defecto `APIClientUseCase`).
    ///   - dataStorageManager: Administrador de almacenamiento de datos.
    init(appState: RootViewModel,
         apiClientUseCase: APIClientUseCaseProtocol = APIClientUseCase(),
         dataStorageManager: DataStorageManager) {
        self.appState = appState
        self.apiClientUseCase = apiClientUseCase
        self.dataStorageManager = dataStorageManager
    }

    // MARK: - Methods
    
    /// Carga la lista de personajes, buscando primero en el almacenamiento local y luego en la API si no están disponibles localmente.
    func loadCharacters() {
        Task {
            // Cambia el estado a `loadingCharacters`
            await MainActor.run { self.appState.state = .loadingCharacters }
            
            var fetchedCharacters: [Character] = []

            for name in listCharacters {
                do {
                    // Intenta obtener los personajes de la base de datos local.
                    let localCharacters = try await dataStorageManager
                        .getCharacter(byName: name)
                        .awaitPublisher()

                    if !localCharacters.isEmpty {
                        fetchedCharacters.append(contentsOf: localCharacters)
                        debugPrint("Character \(name) loaded from local storage.")
                    } else {
                        // Si no se encuentran localmente, obtén de la API.
                        let character = try await apiClientUseCase.getCharacter(by: name, apiRouter: .getCharacter)
                        fetchedCharacters.append(character)
                        debugPrint("Character \(name) loaded from API.")
                        
                        // Guarda el personaje obtenido en la base de datos.
                        try await dataStorageManager.saveCharacter(character).awaitPublisher()
                        debugPrint("Character \(name) added to local storage.")
                    }
                } catch {
                    // Maneja errores cambiando el estado.
                    await MainActor.run {
                        self.appState.state = .error("Error processing character \(name): \(error.localizedDescription)")
                    }
                    return
                }
            }

            // Actualiza los personajes y el estado en el hilo principal.
            await MainActor.run {
                self.characters = fetchedCharacters
                debugPrint("Total characters loaded: \(self.characters.count)")
                self.appState.state = .loadedCharacters
            }
        }
    }
}

// MARK: - Combine Extension for Awaiting Publishers

/// Extensión que permite esperar el resultado de un `Publisher` dentro de un contexto asincrónico.
extension Publisher {
    func awaitPublisher() async throws -> Output {
        try await withCheckedThrowingContinuation { continuation in
            var cancellable: AnyCancellable?
            cancellable = self.sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                    cancellable?.cancel()
                },
                receiveValue: { value in
                    continuation.resume(returning: value)
                    cancellable?.cancel()
                }
            )
        }
    }
}
