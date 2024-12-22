//
//  CharactersView.swift
//  KC_Marvel_JCRC
//
//  Created by Juan Carlos Rubio Casas on 17/12/24.
//

import SwiftUI

// MARK: - CharactersView

/// Vista principal para mostrar una lista de personajes en formato de rejilla.
/// Incluye botones para recargar los datos o salir de la aplicación.
struct CharactersView: View {
    // MARK: - Properties

    /// Rutas de navegación para las vistas.
    @Binding var navigationPath: NavigationPath
    
    /// Estado global de la aplicación.
    @EnvironmentObject var appState: RootViewModel

    // MARK: - Body

    var body: some View {
        VStack {
            // Barra superior con botones de salir y recargar
            HStack {
                Button(action: { exit(0) }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .foregroundColor(.red)
                }
                Spacer()
                Button(action: { appState.charactersViewModel?.loadCharacters() }) {
                    Image(systemName: "arrow.clockwise.circle.fill")
                        .font(.title)
                        .foregroundColor(.blue)
                }
            }
            .padding([.horizontal, .top])

            // Título
            Text("Characters")
                .font(.largeTitle)
                .bold()
                .padding()

            // Contenido principal
            if let charactersViewModel = appState.charactersViewModel {
                charactersGrid(viewModel: charactersViewModel)
            } else {
                loadingView
            }
        }
        .onAppear {
            if appState.state == .none || appState.charactersViewModel?.characters.isEmpty == true {
                appState.initializeCharactersViewModel()
            }
        }
    }

    // MARK: - Subviews

    /// Vista que muestra un mensaje de carga mientras los datos se obtienen.
    private var loadingView: some View {
        Text("Cargando personajes...")
            .font(.headline)
            .padding()
    }

    /// Vista que muestra los personajes en una rejilla de dos columnas.
    private func charactersGrid(viewModel: CharactersViewModel) -> some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ], spacing: 16) {
                ForEach(viewModel.characters, id: \.id) { character in
                    characterButton(character, viewModel: viewModel)
                }
            }
            .padding()
        }
    }

    /// Botón individual que representa un personaje.
    private func characterButton(_ character: Character, viewModel: CharactersViewModel) -> some View {
        Button(action: {
            appState.state = .loadingSeries(character) // Cambia el estado para cargar las series
        }) {
            CharacterCardView(
                viewModel: viewModel,
                photo: "\(character.thumbnail.path).\(character.thumbnail.thumbnailExtension.rawValue)",
                characterName: character.name,
                index: character.id,
                height: 250,
                fontSize: 20
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.yellow, lineWidth: 3)
            )
        }
    }
}

// MARK: - Preview

/// Vista previa para verificar el diseño y la funcionalidad de `CharactersView`.
#Preview {
    let appState = RootViewModel.createPlaceholderInstance()
    CharactersView(navigationPath: .constant(NavigationPath()))
        .environmentObject(appState)
}
