//
//  LoadView.swift
//  KC_Marvel_JCRC
//
//  Created by Juan Carlos Rubio Casas on 15/12/24.
//

import SwiftUI

// MARK: - LoadView

/// Vista de carga que muestra un indicador mientras se cargan datos.
/// Incluye animaciones y texto dinámico para informar al usuario del proceso actual.
struct LoadView: View {
    // MARK: - Properties
    
    /// Texto dinámico que indica qué se está cargando.
    var loadingText: String
    
    /// Modelo de estado de la aplicación.
    @EnvironmentObject var appState: RootViewModel

    // MARK: - Body
    
    var body: some View {
        VStack {
            // Logotipos
            Image("Logo Marvel")
                .resizable()
                .scaledToFit()
                .frame(height: 150)
                .padding(.top)
            
            Image("KeepCoding-Logo")
                .resizable()
                .scaledToFit()
                .frame(height: 150)
                .padding(.top)
            
            // Texto que muestra lo que se está cargando.
            Text(loadingText)
                .frame(height: 50)
                .font(.headline)
            
            Spacer()
            
            // Indicador de progreso.
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(6)
                .padding()
                .colorMultiply(.red) // Indicador de color rojo para resaltar la acción.
            
            Spacer()
            
            // Mensaje adicional para el usuario.
            Text("Cargando...")
                .font(.headline)
                .foregroundColor(.gray)
            
            Spacer()
        }
        .padding()
        .onAppear {
            handleState()
        }
    }

    // MARK: - Métodos Privados

    /// Maneja los estados de la aplicación y toma acción en consecuencia.
    private func handleState() {
        switch appState.state {
        case .none:
            appState.initializeCharactersViewModel()
        case .loadingCharacters, .loadedCharacters, .loadingSeries, .loadedSeries, .loadingSerieDetail, .loadedSerieDetail, .error:
            break
        }
    }
}

// MARK: - Preview

/// Vista previa para verificar el diseño y funcionalidad de `LoadView`.
#Preview {
    let appState = RootViewModel.createPlaceholderInstance()
    appState.state = .none
    return LoadView(loadingText: "Marvel Characters") // Ejemplo con texto dinámico
        .environmentObject(appState)
}
