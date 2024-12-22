//
//  APIError.swift
//  KC_Marvel_JCRC
//
//  Created by Juan Carlos Rubio Casas on 22/12/24.
//

import Foundation

// MARK: - APIError

/// `APIError` define una enumeración de errores comunes que pueden ocurrir durante las operaciones de red o procesamiento de datos.
///
/// Esta enumeración cumple con los protocolos `Error` y `Equatable`, lo que permite usarla en flujos de control
/// de errores y facilitar pruebas unitarias.
enum APIError: Error, Equatable {
    /// Un error desconocido ocurrió.
    case unknown
    
    /// Error generado por una URL malformada.
    case malformedUrl
    
    /// Fallo durante la decodificación de datos (por ejemplo, JSON).
    case decodingFailed
    
    /// Fallo durante la codificación de datos (por ejemplo, JSON).
    case encodingFailed
    
    /// Los datos requeridos no están disponibles.
    case noData
    
    /// Error generado por un código de estado HTTP no esperado.
    ///
    /// - Parameter code: El código de estado HTTP asociado con el error.
    case statusCode(code: Int?)
}
