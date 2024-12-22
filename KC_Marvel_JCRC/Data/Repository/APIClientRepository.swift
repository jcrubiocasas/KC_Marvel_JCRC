//
//  APIClientRepository.swift
//  KC_Marvel_JCRC
//
//  Created by Juan Carlos Rubio Casas on 17/12/24.
//

import Foundation

// MARK: - APIClientRepository

/// Repositorio que sirve como capa intermedia entre la lógica de negocio y el cliente de API.
/// Implementa el protocolo `APIClientRepositoryProtocol` para gestionar las operaciones de red.
final class APIClientRepository: APIClientRepositoryProtocol {
    
    // MARK: - Properties
    
    /// Cliente de API utilizado para realizar las solicitudes de red.
    private var apiClient: APIClientProtocol
    
    // MARK: - Initializers
    
    /// Inicializa el repositorio con un cliente de API específico.
    /// - Parameter apiClient: Una implementación de `APIClientProtocol`. Por defecto, se usa `APIClient`.
    init(apiClient: APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
    }
    
    // MARK: - Functions
    
    /// Obtiene información sobre un personaje específico desde la API.
    /// - Parameters:
    ///   - characterName: El nombre del personaje a buscar.
    ///   - apiRouter: La ruta de la API para realizar la solicitud.
    /// - Returns: Un objeto `Character` con la información obtenida de la API.
    func getCharacter(by characterName: String, apiRouter: APIRouter) async throws -> Character {
        try await apiClient.getCharacter(by: characterName, apiRouter: .getCharacter)
    }
    
    /// Obtiene una lista de series asociadas a un personaje específico desde la API.
    /// - Parameters:
    ///   - characterId: El identificador del personaje.
    ///   - apiRouter: La ruta de la API para realizar la solicitud.
    /// - Returns: Una lista de objetos `Series` con la información obtenida de la API.
    func getSeries(by characterId: Int, apiRouter: APIRouter) async throws -> Series {
        try await apiClient.getSeries(by: characterId, apiRouter: .getSeries(characterId: characterId))
    }
}
