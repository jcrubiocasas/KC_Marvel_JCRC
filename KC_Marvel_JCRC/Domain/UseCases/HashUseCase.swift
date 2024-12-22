//
//  HashUseCase.swift
//  KC_Marvel_JCRC
//
//  Created by Juan Carlos Rubio Casas on 15/12/24.
//

import Foundation
import CryptoKit

// MARK: - HashUseCaseProtocol

/// Protocolo que define las operaciones necesarias para generar un hash para la autenticación de la API de Marvel.
protocol HashUseCaseProtocol {
    /// Genera un hash MD5 basado en el timestamp (`ts`), clave pública y clave privada.
    /// - Parameters:
    ///   - ts: Timestamp utilizado para la generación del hash.
    ///   - apiKeyPublic: Clave pública proporcionada por la API de Marvel.
    ///   - apiKeyPrivate: Clave privada proporcionada por la API de Marvel.
    /// - Returns: Cadena de texto con el hash generado en formato hexadecimal.
    func generateHash(ts: String, apiKeyPublic: String, apiKeyPrivate: String) -> String
    
    /// Genera un hash MD5 a partir de una cadena dada.
    /// - Parameter stringToHash: Cadena de texto que será hasheada.
    /// - Returns: Cadena de texto con el hash generado en formato hexadecimal.
    func marvelHash(stringToHash: String) -> String
}

// MARK: - HashUseCase

/// Implementación del caso de uso para generar hashes de autenticación.
/// Esta clase se encarga de crear un hash MD5 requerido por la API de Marvel.
final class HashUseCase: HashUseCaseProtocol {
    
    /// Genera un hash MD5 combinando el timestamp, la clave privada y la clave pública.
    /// - Parameters:
    ///   - ts: Timestamp proporcionado para la solicitud.
    ///   - apiKeyPublic: Clave pública proporcionada por la API de Marvel.
    ///   - apiKeyPrivate: Clave privada proporcionada por la API de Marvel.
    /// - Returns: Cadena de texto con el hash MD5 generado.
    func generateHash(ts: String, apiKeyPublic: String, apiKeyPrivate: String) -> String {
        let stringToHash: String = ts + apiKeyPrivate + apiKeyPublic
        return marvelHash(stringToHash: stringToHash)
    }
    
    /// Genera un hash MD5 a partir de una cadena de texto.
    /// - Parameter stringToHash: Cadena de texto que será hasheada.
    /// - Returns: Cadena de texto con el hash MD5 generado en formato hexadecimal.
    func marvelHash(stringToHash: String) -> String {
        let data = Data(stringToHash.utf8)
        let hashed = Insecure.MD5.hash(data: data)
        return hashed.map { String(format: "%02hhx", $0) }.joined()
    }
}
