//
//  StartView.swift
//  KC_Marvel_JCRC
//
//  Created by Juan Carlos Rubio Casas on 22/12/24.
//

import SwiftUI

// MARK: - StartView

/// Vista inicial que se muestra al iniciar la aplicación.
/// Presenta una animación del logotipo y una bienvenida al usuario.
struct StartView: View {
    // MARK: - Properties
    
    /// Modelo de estado de la aplicación.
    @EnvironmentObject var appState: RootViewModel
    
    /// Escala inicial de la animación.
    @State private var scale: CGFloat = 0.5
    
    /// Opacidad inicial de la animación.
    @State private var opacity: Double = 0.5

    // MARK: - Body
    
    var body: some View {
        VStack {
            Spacer()
            
            // Logotipo de Marvel con animación.
            Image("Logo Marvel")
                .resizable()
                .scaledToFit()
                .frame(height: 150)
                .scaleEffect(scale)
                .opacity(opacity)
                .onAppear {
                    startAnimation()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        // Inicia la carga de personajes después de la animación.
                        appState.charactersViewModel?.loadCharacters()
                    }
                }
            
            // Logotipo de KeepCoding con animación.
            Image("KeepCoding-Logo")
                .resizable()
                .scaledToFit()
                .frame(height: 150)
                .padding(.top)
                .scaleEffect(scale)
                .opacity(opacity)
                .onAppear {
                    startAnimation()
                }
            
            Spacer()
            
            // Mensaje de bienvenida.
            Text("Bienvenido al Universo Marvel")
                .font(.title)
                .bold()
                .padding()
        }
        .padding()
        .background(Color.black.edgesIgnoringSafeArea(.all)) // Fondo negro para resaltar los logotipos.
    }

    // MARK: - Animación
    
    /// Inicia la animación de escala y opacidad de los logotipos.
    private func startAnimation() {
        withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
            scale = 1.0
            opacity = 1.0
        }
    }
}

// MARK: - Preview

/// Vista de previsualización para verificar el comportamiento de `StartView`.
#Preview {
    let appState = RootViewModel.createPlaceholderInstance()
    StartView()
        .environmentObject(appState)
}
