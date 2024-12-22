//
//  HttpMethods.swift
//  KC_Marvel_JCRC
//
//  Created by Juan Carlos Rubio Casas on 15/12/24.
//

import Foundation

// MARK: - HttpMethods

/// Estructura que define los métodos HTTP comunes y valores relacionados para las solicitudes de red.
struct HttpMethods {
    /// Método HTTP `POST`.
    static let post = "POST"
    
    /// Método HTTP `GET`.
    static let get = "GET"
    
    /// Método HTTP `PUT`.
    static let put = "PUT"
    
    /// Método HTTP `DELETE`.
    static let delete = "DELETE"
    
    /// Valor para indicar el tipo de contenido de las solicitudes/respuestas.
    static let content = "application/json"
    
    /// Encabezado HTTP para definir el tipo de contenido.
    static let contentTypeID = "Content-type"
}
