//
//  MarvelHash.swift
//  KC_Marvel_JCRC
//
//  Created by Juan Carlos Rubio Casas on 15/12/24.
//

import Foundation
import CryptoKit

// MARK: - Marvel Hashing

/// Genera un hash MD5 para la autenticación de solicitudes a la API de Marvel.
///
/// El hash se utiliza como parte del proceso de autenticación en la API de Marvel,
/// combinando un timestamp (`ts`), la clave privada y la clave pública.
///
/// - Parameter stringToHash: La cadena de texto que se desea hashear.
/// - Returns: Una cadena de texto que representa el hash MD5 en formato hexadecimal.
func marvelHash(stringToHash: String) -> String {
    let digest = Insecure.MD5.hash(data: Data(stringToHash.utf8))
    return digest.map { String(format: "%02hhx", $0) }.joined()
}
