//
//  CharacterSeriesViewModel.swift
//  KC_Marvel_JCRC
//
//  Created by Juan Carlos Rubio Casas on 19/12/24.
//

import Foundation
import Combine

// MARK: - CharacterSeriesViewModel

/// ViewModel encargado de gestionar las series asociadas a un personaje específico.
/// Maneja la lógica para obtener las series desde el almacenamiento local o desde la API
/// y actualiza el estado general de la aplicación.
@MainActor
final class CharacterSeriesViewModel: ObservableObject {
    // MARK: - Properties
    
    /// Lista de series asociadas al personaje.
    @Published var series: Series = []
    
    /// Personaje del cual se obtendrán las series.
    public let character: Character
    
    /// Caso de uso para interactuar con la API.
    private let apiClientUseCase: APIClientUseCaseProtocol
    
    /// Administrador de almacenamiento de datos locales.
    private let dataStorageManager: DataStorageManager
    
    /// Referencia al estado principal de la aplicación.
    private let appState: RootViewModel

    // MARK: - Initializer
    
    /// Inicializa el ViewModel.
    /// - Parameters:
    ///   - character: Personaje del cual se cargarán las series.
    ///   - appState: Estado principal de la aplicación.
    ///   - apiClientUseCase: Caso de uso para interactuar con la API (por defecto `APIClientUseCase`).
    ///   - dataStorageManager: Administrador de almacenamiento de datos.
    init(character: Character,
         appState: RootViewModel,
         apiClientUseCase: APIClientUseCaseProtocol = APIClientUseCase(),
         dataStorageManager: DataStorageManager) {
        self.character = character
        self.appState = appState
        self.apiClientUseCase = apiClientUseCase
        self.dataStorageManager = dataStorageManager
        loadSeries()
    }

    // MARK: - Methods
    
    /// Carga las series asociadas al personaje.
    /// Si las series existen en la base de datos local, se cargan directamente desde allí.
    /// Si no, se obtienen de la API y se guardan localmente.
    func loadSeries() {
        Task {
            // Cambia el estado a `loadingSeries` mientras se cargan los datos.
            appState.state = .loadingSeries(character)
            do {
                // Intenta obtener las series desde el almacenamiento local.
                let storedSeries = try await dataStorageManager
                    .getSeries(for: character.id)
                    .awaitPublisher()

                if !storedSeries.isEmpty {
                    // Si se encuentran series en la base de datos local, actualiza la lista y el estado.
                    self.series = storedSeries
                    appState.state = .loadedSeries(character)
                    return
                }

                // Si no hay datos locales, obtén las series desde la API.
                let fetchedSeries = try await apiClientUseCase.getSeries(
                    by: character.id,
                    apiRouter: .getSeries(characterId: character.id)
                )
                // Filtra las series con descripción válida.
                let filteredSeries = fetchedSeries.filter { $0.description != nil }

                // Guarda las series obtenidas en la base de datos local.
                try await dataStorageManager.saveSeries(filteredSeries).awaitPublisher()

                // Actualiza la lista de series y el estado.
                self.series = filteredSeries
                appState.state = .loadedSeries(character)
            } catch {
                // En caso de error, cambia el estado a `error` con el mensaje correspondiente.
                appState.state = .error("Error al cargar las series: \(error.localizedDescription)")
            }
        }
    }
}
