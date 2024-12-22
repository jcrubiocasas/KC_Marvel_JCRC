//
//  ErrorView.swift
//  KC_Marvel_JCRC
//
//  Created by Juan Carlos Rubio Casas on 15/12/24.
//

import SwiftUI

// MARK: - ErrorView

/// Vista para mostrar mensajes de error al usuario.
/// Incluye una descripción del error y un botón para continuar.
struct ErrorView: View {
    // MARK: - Properties
    
    /// Modelo de estado de la aplicación.
    @EnvironmentObject var appState: RootViewModel
    
    /// Mensaje de error que se mostrará en la vista.
    let errorMessage: String

    // MARK: - Body
    
    var body: some View {
        VStack {
            // Logos superiores
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

            // Mensaje principal de error
            Text("Ocurrió un error")
                .font(.title)
                .bold()
                .padding()

            // Detalle del mensaje de error
            Text(errorMessage)
                .font(.body)
                .foregroundColor(.red)
                .multilineTextAlignment(.center)
                .padding()

            // Botón para volver
            Button(action: handleContinue) {
                Text("Continuar")
                    .font(.title2)
                    .frame(width: 300, height: 50)
                    .background(.orange)
                    .foregroundColor(.white)
                    .cornerRadius(15)
                    .shadow(radius: 10, x: 10, y: 10)
            }
            .padding(.top, 40)
        }
        .padding()
    }

    // MARK: - Métodos Privados

    /// Maneja la acción del botón de continuar para navegar según el estado actual.
    private func handleContinue() {
        switch appState.state {
        case .loadingCharacters, .loadedCharacters:
            appState.state = .loadedCharacters
        case .loadingSeries(let character), .loadedSeries(let character):
            appState.state = .loadedSeries(character)
        case .loadingSerieDetail(let serie), .loadedSerieDetail(let serie):
            appState.state = .loadedSerieDetail(serie)
        default:
            appState.state = .none
        }
    }
}

// MARK: - Preview

/// Vista previa para verificar el diseño y funcionalidad de `ErrorView`.
#Preview {
    let dataStorageManager = DataStorageManager()
    let appState = RootViewModel(dataStorageManager: dataStorageManager)
    ErrorView(errorMessage: "Esto es un mensaje de error de ejemplo.")
        .environmentObject(appState)
}
