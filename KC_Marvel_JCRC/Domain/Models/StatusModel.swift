//
//  StatusModel.swift
//  KC_Marvel_JCRC
//
//  Created by Juan Carlos Rubio Casas on 15/12/24.
//

import Foundation

// MARK: - AppState Enum

/// Representa el estado actual de la aplicación y permite gestionar las transiciones entre diferentes pantallas y flujos.
enum AppState: Equatable {
    /// Estado inicial o sin configuración.
    case none
    
    /// Estado de carga de personajes.
    case loadingCharacters
    
    /// Estado en el que los personajes han sido cargados exitosamente.
    case loadedCharacters
    
    /// Estado de carga de las series asociadas a un personaje específico.
    case loadingSeries(Character)
    
    /// Estado en el que las series asociadas a un personaje han sido cargadas exitosamente.
    case loadedSeries(Character)
    
    /// Estado de carga del detalle de una serie específica.
    case loadingSerieDetail(SerieModel)
    
    /// Estado en el que los detalles de una serie específica han sido cargados exitosamente.
    case loadedSerieDetail(SerieModel)
    
    /// Estado de error con un mensaje asociado.
    case error(String)

    // MARK: - Equatable Implementation

    /// Permite comparar dos instancias de `AppState` para determinar si representan el mismo estado.
    static func == (lhs: AppState, rhs: AppState) -> Bool {
        switch (lhs, rhs) {
        case (.none, .none),
             (.loadingCharacters, .loadingCharacters),
             (.loadedCharacters, .loadedCharacters):
            return true
        case let (.loadingSeries(lhsCharacter), .loadingSeries(rhsCharacter)),
             let (.loadedSeries(lhsCharacter), .loadedSeries(rhsCharacter)):
            return lhsCharacter == rhsCharacter
        case let (.loadingSerieDetail(lhsSerie), .loadingSerieDetail(rhsSerie)),
             let (.loadedSerieDetail(lhsSerie), .loadedSerieDetail(rhsSerie)):
            return lhsSerie == rhsSerie
        case let (.error(lhsMessage), .error(rhsMessage)):
            return lhsMessage == rhsMessage
        default:
            return false
        }
    }
}
