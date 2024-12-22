//
//  Extension+URLResponse.swift
//  KC_Marvel_JCRC
//
//  Created by Juan Carlos Rubio Casas on 17/12/24.
//

import Foundation

// MARK: - URLResponse Extension

/// Extensión para `URLResponse` que permite obtener fácilmente el código de estado HTTP de una respuesta.
extension URLResponse {
    
    /// Obtiene el código de estado HTTP de la respuesta, si está disponible.
    /// - Returns: El código de estado HTTP como un `Int`, o `nil` si la respuesta no es una instancia de `HTTPURLResponse`.
    func getStatusCode() -> Int? {
        if let httpResponse = self as? HTTPURLResponse {
            return httpResponse.statusCode
        }
        return nil
    }
}
