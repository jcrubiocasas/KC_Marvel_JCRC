//
//  APIClient.swift
//  KC_Marvel_JCRC
//
//  Created by Juan Carlos Rubio Casas on 17/12/24.
//

import Foundation

// MARK: - APIClientProtocol

/// Protocolo que define las operaciones de red para interactuar con la API de Marvel.
protocol APIClientProtocol {
    
    /// Obtiene un personaje de la API.
    /// - Parameters:
    ///   - characterName: El nombre del personaje a buscar.
    ///   - apiRouter: La ruta de la API para realizar la solicitud.
    /// - Returns: Un objeto `Character` obtenido de la API.
    func getCharacter(by characterName: String, apiRouter: APIRouter) async throws -> Character
    
    /// Obtiene una lista de series asociadas a un personaje de la API.
    /// - Parameters:
    ///   - characterId: El identificador del personaje.
    ///   - apiRouter: La ruta de la API para realizar la solicitud.
    /// - Returns: Una lista de objetos `Series`.
    func getSeries(by characterId: Int, apiRouter: APIRouter) async throws -> Series
}

// MARK: - APIRouter

/// Enum que define las rutas y configuraciones de la API de Marvel.
enum APIRouter {
    case getCharacter
    case getSeries(characterId: Int)
    
    /// Host de la API.
    var host: String {
        return "gateway.marvel.com"
    }
    
    /// Esquema de la API (http/https).
    var scheme: String {
        return "https"
    }
    
    /// Ruta específica de cada caso.
    var path: String {
        switch self {
        case .getCharacter:
            return "/v1/public/characters"
        case .getSeries(let characterId):
            return "/v1/public/characters/\(characterId)/series"
        }
    }
    
    /// Método HTTP para cada caso.
    var method: String {
        return "GET"
    }
}

// MARK: - APIClient

/// Cliente de red que implementa las operaciones definidas en `APIClientProtocol`.
final class APIClient: APIClientProtocol {
    
    // MARK: - APIError
    
    /// Errores posibles al interactuar con la API.
    enum APIError: Error, Equatable {
        case unknown
        case malformedUrl
        case decodingFailed
        case encodingFailed
        case noData
        case statusCode(code: Int?)
    }
    
    // MARK: - Functions
    
    /// Obtiene un personaje de la API.
    func getCharacter(by characterName: String, apiRouter: APIRouter) async throws -> Character {
        var components = URLComponents()
        components.host = apiRouter.host
        components.scheme = apiRouter.scheme
        components.path = apiRouter.path
        
        // Parámetros de la solicitud
        components.queryItems = [
            URLQueryItem(name: "apikey", value: APICredentials.apiPublicKey),
            URLQueryItem(name: "ts", value: APICredentials.ts),
            URLQueryItem(name: "hash", value: APICredentials.hash),
            URLQueryItem(name: "orderBy", value: APICredentials.orderBy),
            URLQueryItem(name: "name", value: characterName)
        ]
        
        guard let url = components.url else {
            throw APIError.malformedUrl
        }
        
        let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url))
        let statusCode = response.getStatusCode()
        guard statusCode == 200 else {
            throw APIError.statusCode(code: statusCode)
        }
        
        guard !data.isEmpty else {
            throw APIError.noData
        }
        
        guard let resource = try? JSONDecoder().decode(CharacterResults.self, from: data),
              let character = resource.characters.first else {
            throw APIError.decodingFailed
        }
        
        return character
    }
    
    /// Obtiene una lista de series asociadas a un personaje.
    func getSeries(by characterId: Int, apiRouter: APIRouter) async throws -> Series {
        var components = URLComponents()
        components.host = apiRouter.host
        components.scheme = apiRouter.scheme
        components.path = apiRouter.path
        
        // Parámetros de la solicitud
        components.queryItems = [
            URLQueryItem(name: "apikey", value: APICredentials.apiPublicKey),
            URLQueryItem(name: "ts", value: APICredentials.ts),
            URLQueryItem(name: "hash", value: APICredentials.hash),
            URLQueryItem(name: "limit", value: "50")
        ]
        
        guard let url = components.url else {
            throw APIError.malformedUrl
        }
        
        let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url))
        let statusCode = response.getStatusCode()
        guard statusCode == 200 else {
            throw APIError.statusCode(code: statusCode)
        }
        
        guard !data.isEmpty else {
            throw APIError.noData
        }
        
        do {
            let resource = try JSONDecoder().decode(SerieResultsAPI.self, from: data)
            return resource.series.map { serieAPI in
                SerieModel(
                    id: serieAPI.id,
                    title: serieAPI.title,
                    description: serieAPI.description,
                    thumbnail: serieAPI.thumbnail,
                    characterId: characterId
                )
            }
        } catch {
            throw APIError.decodingFailed
        }
    }
}

// MARK: - APIClientFakeSuccess

/// Implementación de prueba que simula el éxito en las respuestas de la API.
final class APIClientFakeSuccess: APIClientProtocol {
    
    func getCharacter(by characterName: String, apiRouter: APIRouter) async throws -> Character {
        return Character(
            id: Int.random(in: 1..<1000),
            name: characterName,
            description: "Description for \(characterName).",
            thumbnail: CharacterThumbnail(
                path: "http://example.com/\(characterName.lowercased())",
                thumbnailExtension: .jpg
            )
        )
    }
    
    func getSeries(by characterId: Int, apiRouter: APIRouter) async throws -> Series {
        return [
            SerieModel(
                id: 1,
                title: "Series One",
                description: "Description for Series One.",
                thumbnail: SerieThumbnail(path: "http://example.com/series1", thumbnailExtension: "jpg"),
                characterId: characterId
            ),
            SerieModel(
                id: 2,
                title: "Series Two",
                description: "Description for Series Two.",
                thumbnail: SerieThumbnail(path: "http://example.com/series2", thumbnailExtension: "jpg"),
                characterId: characterId
            )
        ]
    }
}
