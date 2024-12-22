//
//  Serie.swift
//  KC_Marvel_JCRC
//
//  Created by Juan Carlos Rubio Casas on 15/12/24.
//

import Foundation

// MARK: - Typealias

/// Alias para representar una lista de series.
typealias Series = [SerieModel]

/// Alias para representar una lista de series descargadas desde la API.
typealias SeriesAPI = [SerieAPI]

// MARK: - SerieModel

/// Modelo que representa una serie asociada a un personaje.
struct SerieModel: Decodable, Identifiable, Equatable, Hashable {
    /// Identificador único de la serie.
    let id: Int
    
    /// Título de la serie.
    let title: String
    
    /// Descripción de la serie.
    let description: String?
    
    /// Información del thumbnail de la serie.
    let thumbnail: SerieThumbnail
    
    /// ID del personaje al que está asociada la serie.
    let characterId: Int
    
    /// Conformidad al protocolo `Hashable`.
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    /// Comparación de igualdad entre dos series basada en su `id`.
    static func == (lhs: SerieModel, rhs: SerieModel) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - SerieAPI

/// Modelo que representa una serie descargada desde la API.
struct SerieAPI: Decodable, Identifiable, Equatable {
    /// Identificador único de la serie.
    let id: Int
    
    /// Título de la serie.
    let title: String
    
    /// Descripción de la serie.
    let description: String?
    
    /// Información del thumbnail de la serie.
    let thumbnail: SerieThumbnail
}

// MARK: - SerieThumbnail

/// Modelo que representa la imagen (thumbnail) de una serie.
struct SerieThumbnail: Decodable, Equatable, Hashable {
    /// Ruta de la imagen.
    let path: String
    
    /// Extensión del archivo de la imagen (por ejemplo, `.jpg` o `.gif`).
    let thumbnailExtension: String

    enum CodingKeys: String, CodingKey {
        case path
        case thumbnailExtension = "extension"
    }
}

// MARK: - SerieResults

/// Modelo que representa los resultados de la respuesta de la API al obtener series.
struct SerieResults: Decodable {
    /// Lista de series obtenidas desde la API.
    let series: Series
        
    enum CodingKeys: String, CodingKey {
        case data
        case results
    }
    
    /// Inicializador para decodificar la respuesta anidada de la API.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let data = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        self.series = try data.decode([SerieModel].self, forKey: .results)
    }
}

// MARK: - SerieResultsAPI

/// Modelo que representa los resultados de la respuesta de la API al obtener series (formato API).
struct SerieResultsAPI: Decodable {
    /// Lista de series descargadas desde la API.
    let series: SeriesAPI
    
    enum CodingKeys: String, CodingKey {
        case data
        case results
    }
    
    /// Inicializador para decodificar la respuesta anidada de la API.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let data = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        self.series = try data.decode([SerieAPI].self, forKey: .results)
    }
}

// MARK: - SerieModelWrapper

/// Modelo envolvente para mostrar datos de una serie en una vista.
struct SerieModelWrapper: Hashable, Identifiable {
    /// Serie contenida en el modelo.
    let serie: SerieModel

    /// Identificador único del modelo, basado en el ID de la serie.
    var id: Int { serie.id }

    /// Conformidad al protocolo `Hashable`.
    func hash(into hasher: inout Hasher) {
        hasher.combine(serie.id)
    }

    /// Comparación de igualdad entre dos envolturas de serie basada en el ID de la serie.
    static func == (lhs: SerieModelWrapper, rhs: SerieModelWrapper) -> Bool {
        return lhs.serie.id == rhs.serie.id
    }
}
