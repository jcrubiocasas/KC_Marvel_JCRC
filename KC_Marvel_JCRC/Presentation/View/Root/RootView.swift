//
//  RootView.swift
//  KC_Marvel_JCRC
//
//  Created by Juan Carlos Rubio Casas on 15/12/24.
//

import SwiftUI

// MARK: - RootView

/// Vista principal de la aplicación que gestiona la navegación entre diferentes estados y pantallas.
/// Utiliza un `NavigationStack` para administrar el flujo de navegación.
struct RootView: View {
    // MARK: - Properties
    
    /// Modelo de estado de la aplicación.
    @EnvironmentObject var appState: RootViewModel

    // MARK: - Body
    
    var body: some View {
        NavigationStack(path: $appState.navigationPath) {
            Group {
                switch appState.state {
                case .none:
                    /// Vista inicial para configuración o instrucciones iniciales.
                    StartView()
                        .environmentObject(appState)
                case .loadingCharacters:
                    /// Vista de carga para la descarga de personajes.
                    LoadView(loadingText: "Cargando personajes...")
                case .loadedCharacters:
                    /// Vista de lista de personajes después de cargar los datos.
                    CharactersView(navigationPath: $appState.navigationPath)
                        .environmentObject(appState)
                case .loadingSeries(let character),
                     .loadedSeries(let character):
                    /// Vista de detalle del personaje, muestra las series relacionadas.
                    CharacterDetailView(
                        navigationPath: $appState.navigationPath,
                        character: character,
                        appState: appState
                    )
                    .environmentObject(appState)
                case .loadingSerieDetail(let serie):
                    /// Vista de carga para detalles de una serie.
                    SerieDetailView(
                        navigationPath: $appState.navigationPath,
                        serie: serie,
                        appState: appState
                    )
                    .environmentObject(appState)
                case .loadedSerieDetail:
                    /// Vista inicial después de cargar el detalle de la serie.
                    StartView() // Redirigir si no hay lógica específica.
                case .error(let message):
                    /// Vista de error para manejar problemas durante las operaciones.
                    ErrorView(errorMessage: message)
                        .environmentObject(appState)
                }
            }
        }
    }
}

// MARK: - Preview

/// Vista de previsualización para verificar el comportamiento de `RootView`.
#Preview {
    let dataStorageManager = DataStorageManager()
    let appState = RootViewModel(dataStorageManager: dataStorageManager)

    return RootView()
        .environmentObject(appState)
}
