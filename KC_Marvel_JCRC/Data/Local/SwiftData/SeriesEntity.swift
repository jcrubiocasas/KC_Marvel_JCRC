//
//  SeriesEntity.swift
//  KC_Marvel_JCRC
//
//  Created by Juan Carlos Rubio Casas on 19/12/24.
//

import SwiftData

// MARK: - SeriesEntity

/// **SeriesEntity**
/// Representa una serie de Marvel almacenada en la base de datos local.
///
/// Utiliza `@Model` de SwiftData para definir las propiedades que serán persistidas.
@Model
final class SeriesEntity {
    
    // MARK: - Properties
    
    /// Identificador único de la serie.
    @Attribute(.unique) var id: Int
    
    /// Título de la serie.
    var title: String
    
    /// Descripción opcional de la serie.
    var descriptionText: String?
    
    /// Ruta de la imagen de la serie.
    var thumbnailPath: String
    
    /// Extensión de la imagen de la serie.
    var thumbnailExtension: String
    
    /// Identificador del personaje asociado a la serie.
    var characterId: Int
    
    // MARK: - Initializer
    
    /// Inicializa una nueva entidad de serie.
    /// - Parameters:
    ///   - id: Identificador único de la serie.
    ///   - title: Título de la serie.
    ///   - descriptionText: Descripción opcional de la serie.
    ///   - thumbnailPath: Ruta de la imagen de la serie.
    ///   - thumbnailExtension: Extensión de la imagen de la serie.
    ///   - characterId: Identificador del personaje asociado a la serie.
    init(id: Int, title: String, descriptionText: String?, thumbnailPath: String, thumbnailExtension: String, characterId: Int) {
        self.id = id
        self.title = title
        self.descriptionText = descriptionText
        self.thumbnailPath = thumbnailPath
        self.thumbnailExtension = thumbnailExtension
        self.characterId = characterId
    }
}
