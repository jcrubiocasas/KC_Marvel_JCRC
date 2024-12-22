//
//  ConstantApp.swift
//  KC_Marvel_JCRC
//
//  Created by Juan Carlos Rubio Casas on 15/12/24.
//

import Foundation

// MARK: - ConstantsApp

/// Estructura que contiene las constantes de configuración principales de la aplicación.
public struct ConstantsApp {
    /// URL base del backend de Marvel API.
    /// Nota: Idealmente, esta URL debería estar cifrada utilizando `CryptoKit` para mayor seguridad.
    public static let CONS_API_URL = "https://gateway.marvel.com:443"
    
    /// Identificador para el almacenamiento seguro en Keychain.
    public static let CONS_HASH_KEYCHAIN = "com.keepcoding.SwiftUI.Marvel2024"
    
    /// Timestamp (`ts`) utilizado para generar el hash en la autenticación de la API.
    public static let CONST_TS = "1"
    
    /// Clave pública proporcionada por Marvel API.
    public static let CONST_PUBLIC_KEY = "fe5e0c89b97715ba0eda05347b420c35"
    
    /// Clave privada proporcionada por Marvel API.
    //public static let CONST_PRIVATE_KEY = "2f7ce17868954b414ad4f19e2be9f3e624e80ab4"
    
    /// Hash MD5 generado combinando `ts`, la clave privada y la clave pública.
    public static let CONST_HASH_MD5 = "50ef963b1a3c66d137c6f1208ddb7773"
}

// MARK: - APICredentials

/// Estructura que contiene las credenciales utilizadas para autenticarse con Marvel API.
struct APICredentials {
    /// Clave pública para la autenticación.
    public static var apiPublicKey = "fe5e0c89b97715ba0eda05347b420c35"
    
    /// Clave privada para la autenticación.
    //public static var apiPrivateKey = "2f7ce17868954b414ad4f19e2be9f3e624e80ab4"
    
    /// Timestamp (`ts`) utilizado para generar el hash.
    public static var ts = "1"
    
    /// Hash MD5 precomputado utilizado para autenticación.
    public static var hash = "50ef963b1a3c66d137c6f1208ddb7773"
    
    /// Orden predeterminado para las consultas a la API.
    public static let orderBy = "-modified"
}
