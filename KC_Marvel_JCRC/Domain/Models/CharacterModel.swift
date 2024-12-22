//
//  Character.swift
//  KC_Marvel_JCRC
//
//  Created by Juan Carlos Rubio Casas on 15/12/24.
//

import Foundation

// MARK: - Typealias

/// Alias para representar una lista de personajes.
typealias Characters = [Character]

// MARK: - Character

/// Modelo que representa un personaje de Marvel.
struct Character: Decodable, Identifiable, Equatable, Hashable {
    /// Identificador único del personaje.
    let id: Int
    
    /// Nombre del personaje.
    let name: String
    
    /// Descripción del personaje.
    let description: String
    
    /// Información del thumbnail del personaje.
    let thumbnail: CharacterThumbnail
    
    /// Conformidad al protocolo `Hashable`.
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    /// Comparación de igualdad entre dos personajes basada en su `id`.
    static func == (lhs: Character, rhs: Character) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - CharacterThumbnail

/// Modelo que representa la imagen del personaje.
struct CharacterThumbnail: Decodable, Equatable, Hashable {
    /// Ruta de la imagen.
    let path: String
    
    /// Extensión del archivo de la imagen (por ejemplo, `.jpg` o `.gif`).
    let thumbnailExtension: Extension

    enum CodingKeys: String, CodingKey {
        case path
        case thumbnailExtension = "extension"
    }
}

// MARK: - Extension

/// Enum que representa las extensiones de los archivos de imagen.
enum Extension: String, Decodable, Equatable, Hashable {
    case gif = "gif"
    case jpg = "jpg"
}

// MARK: - CharacterResults

/// Modelo que representa los resultados de la respuesta de la API al obtener personajes.
struct CharacterResults: Decodable {
    /// Lista de personajes obtenidos de la API.
    let characters: Characters

    enum CodingKeys: String, CodingKey {
        case data
        case results
    }

    /// Inicializador para decodificar la respuesta anidada de la API.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let data = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        self.characters = try data.decode(Characters.self, forKey: .results)
    }
}
