//
//  KC_Marvel_JCRCApp.swift
//  KC_Marvel_JCRC
//
//  Created by Juan Carlos Rubio Casas on 14/12/24.
//

import SwiftUI

/// **KC_Marvel_JCRCApp**
/// - Punto de entrada principal de la aplicación.
/// - Configura el estado inicial de la aplicación y la vista raíz.
@main
struct KC_Marvel_JCRCApp: App {
    
    // MARK: - Properties
    
    /// Estado global de la aplicación, que incluye la gestión de almacenamiento de datos y navegación.
    @StateObject private var appState = RootViewModel(
        dataStorageManager: DataStorageManager()
    )

    // MARK: - Scene Configuration

    /// Define la ventana principal de la aplicación.
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState) // Proporciona `appState` como un objeto de entorno global.
        }
    }
}
