//
//  HttpResponseCodes.swift
//  KC_Marvel_JCRC
//
//  Created by Juan Carlos Rubio Casas on 15/12/24.
//

import Foundation

// MARK: - HttpResponseCodes

/// Estructura que define los códigos de respuesta del servidor HTTP más comunes utilizados en la aplicación.
struct HttpResponseCodes {
    /// Código de éxito general (`200 OK`).
    static let SUCCESS = 200
    
    /// Código para éxito al crear un recurso (`201 Created`).
    static let SUCCESS_CREATE = 201
    
    /// Código de error por falta de autorización (`401 Unauthorized`).
    static let NOT_AUTHORIZED = 401
    
    /// Código de error general del servidor (`502 Bad Gateway`).
    static let ERROR = 502
}
