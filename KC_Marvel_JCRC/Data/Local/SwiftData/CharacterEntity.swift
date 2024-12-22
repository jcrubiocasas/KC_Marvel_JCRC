//
//  CharacterEntity.swift
//  KC_Marvel_JCRC
//
//  Created by Juan Carlos Rubio Casas on 19/12/24.
//

import Foundation
import SwiftData

// MARK: - CharacterEntity

/// **CharacterEntity**
/// Representa un personaje de Marvel almacenado en la base de datos local.
///
/// Utiliza `@Model` de SwiftData para definir las propiedades que serán persistidas.
@Model
class CharacterEntity {
    
    // MARK: - Properties
    
    /// Identificador único del personaje.
    @Attribute(.unique) var id: Int
    
    /// Nombre del personaje.
    var name: String
    
    /// Descripción del personaje.
    var characterDescription: String
    
    /// Ruta de la imagen del personaje.
    var thumbnailPath: String
    
    /// Extensión de la imagen del personaje.
    var thumbnailExtension: String
    
    // MARK: - Initializer
    
    /// Inicializa una nueva entidad de personaje.
    /// - Parameters:
    ///   - id: Identificador único del personaje.
    ///   - name: Nombre del personaje.
    ///   - characterDescription: Descripción del personaje.
    ///   - thumbnailPath: Ruta de la imagen del personaje.
    ///   - thumbnailExtension: Extensión de la imagen del personaje.
    init(id: Int, name: String, characterDescription: String, thumbnailPath: String, thumbnailExtension: String) {
        self.id = id
        self.name = name
        self.characterDescription = characterDescription
        self.thumbnailPath = thumbnailPath
        self.thumbnailExtension = thumbnailExtension
    }
}
