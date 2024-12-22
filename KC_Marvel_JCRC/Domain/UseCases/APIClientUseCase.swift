//
//  APIClientUseCase.swift
//  KC_Marvel_JCRC
//
//  Created by Juan Carlos Rubio Casas on 17/12/24.
//

import Foundation

// MARK: - APIClientUseCaseProtocol

/// Protocolo que define las operaciones del caso de uso relacionadas con la interacción con la API.
///
/// Este protocolo abstrae la lógica para obtener personajes y series desde un repositorio subyacente.
protocol APIClientUseCaseProtocol {
    /// Repositorio que maneja las solicitudes a la API.
    var repository: APIClientRepositoryProtocol { get set }
    
    /// Obtiene un personaje por su nombre utilizando un `APIRouter`.
    /// - Parameters:
    ///   - characterName: Nombre del personaje a buscar.
    ///   - apiRouter: Configuración de la ruta API.
    /// - Returns: El personaje correspondiente.
    func getCharacter(by characterName: String, apiRouter: APIRouter) async throws -> Character
    
    /// Obtiene las series asociadas a un ID de personaje utilizando un `APIRouter`.
    /// - Parameters:
    ///   - characterId: ID del personaje.
    ///   - apiRouter: Configuración de la ruta API.
    /// - Returns: Las series asociadas al personaje.
    func getSeries(by characterId: Int, apiRouter: APIRouter) async throws -> Series
}

// MARK: - APIClientUseCase

/// Implementación del caso de uso que interactúa con el repositorio de la API.
final class APIClientUseCase: APIClientUseCaseProtocol {
    // MARK: - Properties
    var repository: APIClientRepositoryProtocol
    
    // MARK: - Initializers
    /// Inicializa una instancia de `APIClientUseCase` con un repositorio.
    /// - Parameter repository: Repositorio que maneja las solicitudes de datos.
    init(repository: APIClientRepositoryProtocol = APIClientRepository()) {
        self.repository = repository
    }
    
    // MARK: - Functions
    func getCharacter(by characterName: String, apiRouter: APIRouter) async throws -> Character {
        try await repository.getCharacter(by: characterName, apiRouter: .getCharacter)
    }
    
    func getSeries(by characterId: Int, apiRouter: APIRouter) async throws -> Series {
        try await repository.getSeries(by: characterId, apiRouter: .getSeries(characterId: characterId))
    }
}

// MARK: - APIClientUseCaseFakeSuccess

/// Caso de uso simulado para pruebas con respuestas exitosas.
final class APIClientUseCaseFakeSuccess: APIClientUseCaseProtocol {
    // MARK: - Properties
    var repository: APIClientRepositoryProtocol
    
    // MARK: - Initializers
    /// Inicializa una instancia de `APIClientUseCaseFakeSuccess` con un repositorio simulado.
    /// - Parameter repository: Repositorio que maneja las solicitudes simuladas.
    init(repository: APIClientRepositoryProtocol = APIClientRepository(apiClient: APIClientFakeSuccess())) {
        self.repository = repository
    }
    
    // MARK: - Functions
    func getCharacter(by characterName: String, apiRouter: APIRouter) async throws -> Character {
        try await repository.getCharacter(by: characterName, apiRouter: .getCharacter)
    }
    
    func getSeries(by characterId: Int, apiRouter: APIRouter) async throws -> Series {
        try await repository.getSeries(by: characterId, apiRouter: .getSeries(characterId: characterId))
    }
}

// MARK: - APIClientFakeError

/// Implementación simulada de `APIClientProtocol` que siempre lanza errores.
/// Útil para probar el manejo de errores.
final class APIClientFakeError: APIClientProtocol {
    func getCharacter(by characterName: String, apiRouter: APIRouter) async throws -> Character {
        throw APIError.noData
    }
    
    func getSeries(by characterId: Int, apiRouter: APIRouter) async throws -> Series {
        throw APIError.statusCode(code: 404)
    }
}
