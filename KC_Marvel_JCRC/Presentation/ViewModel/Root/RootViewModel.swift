//
//  RootViewModel.swift
//  KC_Marvel_JCRC
//
//  Created by Juan Carlos Rubio Casas on 16/12/24.
//

import Foundation
import Combine
import SwiftUI

// MARK: - RootViewModel

/// ViewModel principal de la aplicación que administra el estado global, la navegación y la interacción con el almacenamiento local y remoto.
@MainActor
final class RootViewModel: ObservableObject {
    // MARK: - Properties
    
    /// Estado global de la aplicación.
    @Published var state: AppState = .none
    
    /// Ruta de navegación utilizada para controlar las transiciones entre pantallas.
    @Published var navigationPath = NavigationPath()
    
    /// ViewModel para la gestión de los personajes.
    @Published var charactersViewModel: CharactersViewModel?
    
    /// Personaje seleccionado actualmente.
    @Published var actualCharacter: Character?
    
    /// Instancia del administrador de almacenamiento de datos.
    public let dataStorageManager: DataStorageManager
    
    /// Conjunto de suscripciones para Combine.
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initializer
    
    /// Inicializa el `RootViewModel` con un administrador de almacenamiento de datos.
    /// - Parameter dataStorageManager: Administrador de almacenamiento de datos utilizado para operaciones locales.
    init(dataStorageManager: DataStorageManager) {
        self.state = .none
        self.dataStorageManager = dataStorageManager
        self.charactersViewModel = CharactersViewModel(appState: self, dataStorageManager: dataStorageManager)
    }

    // MARK: - Methods
    
    /// Inicia la carga de personajes desde el almacenamiento local o remoto.
    func initializeCharacters() {
        state = .loadingCharacters
        charactersViewModel?.loadCharacters()
    }
    
    /// Inicializa el ViewModel de los personajes si no está configurado.
    func initializeCharactersViewModel() {
        if charactersViewModel == nil {
            self.charactersViewModel = CharactersViewModel(appState: self, dataStorageManager: dataStorageManager)
            self.state = .loadingCharacters
        }
    }

    /// Borra los datos almacenados localmente, incluyendo Keychain y la base de datos.
    func deleteLocalStorage() async {
        let result = await dataStorageManager.deleteLocalStorage(keychainKey: ConstantsApp.CONS_HASH_KEYCHAIN)
        await MainActor.run {
            if result {
                state = .none
                debugPrint("Keychain y base de datos borrados correctamente.")
            } else {
                state = .error("Error al borrar Keychain y base de datos.")
            }
        }
    }

    /// Selecciona un personaje y actualiza el estado para cargar las series asociadas.
    /// - Parameter character: El personaje seleccionado.
    func selectCharacter(_ character: Character) {
        actualCharacter = character
        state = .loadingSeries(character)
    }

    /// Maneja errores y actualiza el estado con un mensaje de error.
    /// - Parameter message: Mensaje de error a mostrar.
    func handleError(_ message: String) {
        state = .error(message)
    }
}

// MARK: - Factory Methods

extension RootViewModel {
    /// Crea una instancia de `RootViewModel` con un entorno completamente funcional.
    /// - Returns: Una nueva instancia de `RootViewModel`.
    static func createInstance() async -> RootViewModel {
        let dataStorageManager = DataStorageManager()
        return RootViewModel(dataStorageManager: dataStorageManager)
    }

    /// Crea una instancia de `RootViewModel` para propósitos de prueba o vista previa.
    /// - Returns: Una instancia de `RootViewModel` configurada con datos de marcador de posición.
    static func createPlaceholderInstance() -> RootViewModel {
        let placeholderStorageManager = DataStorageManager()
        return RootViewModel(dataStorageManager: placeholderStorageManager)
    }
}
