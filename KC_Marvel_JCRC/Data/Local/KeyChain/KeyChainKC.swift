//
//  KeyChainKC.swift
//  KC_Marvel_JCRC
//
//  Created by Juan Carlos Rubio Casas on 15/12/24.
//

import Foundation
import KeychainSwift

// MARK: - KeyChainProtocol

/// Protocolo para definir las operaciones básicas del Keychain.
/// - saveKC: Guarda un valor asociado a una clave.
/// - loadKC: Recupera un valor almacenado.
/// - deleteKC: Elimina un valor asociado a una clave.
protocol KeyChainProtocol {
    func saveKC(key: String, value: String) -> Bool
    func loadKC(key: String) -> String
    func deleteKC(key: String) -> Bool
}

// MARK: - KeyChainKC

/// Implementación de `KeyChainProtocol` utilizando la librería KeychainSwift.
public struct KeyChainKC: KeyChainProtocol {
    
    // MARK: - Initializer
    
    /// Inicializador público requerido.
    public init() {}
    
    // MARK: - Funciones de KeyChain
    
    /// Guarda un valor en el Keychain.
    /// - Parameters:
    ///   - key: La clave para identificar el valor.
    ///   - value: El valor a guardar.
    /// - Returns: `true` si el valor fue guardado correctamente, `false` en caso contrario.
    @discardableResult
    public func saveKC(key: String, value: String) -> Bool {
        if let data = value.data(using: .utf8) {
            let keychain = KeychainSwift()
            return keychain.set(data, forKey: key)
        } else {
            return false // Error en la conversión del valor a Data.
        }
    }
    
    /// Recupera un valor almacenado en el Keychain.
    /// - Parameter key: La clave asociada al valor.
    /// - Returns: El valor almacenado o una cadena vacía si no se encuentra.
    public func loadKC(key: String) -> String {
        let keychain = KeychainSwift()
        return keychain.get(key) ?? ""
    }
    
    /// Elimina un valor del Keychain.
    /// - Parameter key: La clave asociada al valor a eliminar.
    /// - Returns: `true` si el valor fue eliminado correctamente, `false` si la clave no existe.
    @discardableResult
    public func deleteKC(key: String) -> Bool {
        let keychain = KeychainSwift()
        let exists = keychain.get(key) != nil
        
        guard exists else {
            debugPrint("Key \(key) no existe en Keychain.")
            return false
        }
        
        let success = keychain.delete(key)
        if !success {
            debugPrint("Error al eliminar \(key) del Keychain.")
        }
        return success
    }
}

// MARK: - MockKeyChainKC

/// Clase mock para simular las operaciones de Keychain.
/// Ideal para pruebas unitarias.
class MockKeyChainKC: KeyChainProtocol {
    
    // MARK: - Properties
    
    /// Almacenamiento simulado.
    private var storage: [String: String] = [:]
    
    // MARK: - Funciones del Mock
    
    /// Simula guardar un valor en el Keychain.
    func saveKC(key: String, value: String) -> Bool {
        storage[key] = value
        return true
    }
    
    /// Simula recuperar un valor almacenado.
    func loadKC(key: String) -> String {
        return storage[key] ?? ""
    }
    
    /// Simula eliminar un valor del Keychain.
    func deleteKC(key: String) -> Bool {
        guard storage[key] != nil else {
            return false // La clave no existe.
        }
        storage.removeValue(forKey: key)
        return true // La clave fue eliminada.
    }
}
