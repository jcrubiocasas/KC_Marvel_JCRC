//
//  kcPersistenceKeyChain.swift
//  KC_Marvel_JCRC
//
//  Created by Juan Carlos Rubio Casas on 15/12/24.
//

import Foundation

// MARK: - kcPersistenceKeyChain

/// `kcPersistenceKeyChain` es un `@propertyWrapper` diseñado para simplificar el acceso y la persistencia de datos en Keychain.
///
/// Este envoltorio permite guardar y recuperar valores asociados con una clave específica en Keychain
/// utilizando una interfaz sencilla de propiedades. Internamente, utiliza la clase `KeyChainKC` para interactuar con Keychain.
@propertyWrapper
class kcPersistenceKeyChain {
    // MARK: - Properties
    
    /// Clave utilizada para identificar el valor en Keychain.
    private var key: String
    
    // MARK: - Initializer
    
    /// Inicializa el envoltorio con una clave específica para Keychain.
    ///
    /// - Parameter key: La clave asociada con el valor a persistir en Keychain.
    init(key: String) {
        self.key = key
    }
    
    // MARK: - Wrapped Value
    
    /// El valor envuelto, que se almacena o recupera de Keychain.
    ///
    /// - `get`: Recupera el valor almacenado en Keychain asociado con la clave.
    /// - `set`: Guarda un nuevo valor en Keychain asociado con la clave.
    var wrappedValue: String {
        get {
            KeyChainKC().loadKC(key: self.key)
        }
        set {
            KeyChainKC().saveKC(key: self.key, value: newValue)
        }
    }
}
