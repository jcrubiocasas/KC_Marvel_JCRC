//
//  CharacterDetailView.swift
//  KC_Marvel_JCRC
//
//  Created by Juan Carlos Rubio Casas on 15/12/24.
//

import SwiftUI

// MARK: - CharacterDetailView -

/// Vista que muestra los detalles de un personaje, incluidas sus series asociadas.
struct CharacterDetailView: View {
    // MARK: - Properties -

    /// Ruta de navegación, para gestionar la navegación entre vistas.
    @Binding var navigationPath: NavigationPath

    /// Personaje actual cuyos detalles se mostrarán.
    let character: Character

    /// Modelo del estado global de la aplicación.
    @EnvironmentObject var appState: RootViewModel

    /// ViewModel que maneja la lógica de negocio para cargar series relacionadas con el personaje.
    @StateObject private var seriesViewModel: CharacterSeriesViewModel

    // MARK: - Initializer -

    init(
        navigationPath: Binding<NavigationPath>,
        character: Character,
        appState: RootViewModel
    ) {
        self._navigationPath = navigationPath
        self.character = character
        _seriesViewModel = StateObject(wrappedValue: CharacterSeriesViewModel(
            character: character,
            appState: appState,
            dataStorageManager: appState.dataStorageManager
        ))
    }

    // MARK: - Body -

    var body: some View {
        VStack {
            // Nombre del personaje
            Text(character.name)
                .font(.largeTitle)
                .padding()

            // Imagen del personaje
            AsyncImage(url: URL(string: "\(character.thumbnail.path).\(character.thumbnail.thumbnailExtension.rawValue)")) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
            } placeholder: {
                ProgressView()
            }

            // Descripción del personaje
            if !character.description.isEmpty {
                Text(character.description)
                    .padding()
            } else {
                Text("Descripción no disponible")
                    .italic()
                    .foregroundColor(.gray)
                    .padding()
            }

            // Series asociadas
            if seriesViewModel.series.isEmpty {
                Text("Cargando series...")
                    .italic()
                    .foregroundColor(.gray)
                    .padding()
            } else {
                seriesScrollView
            }

            Spacer()
        }
        .padding()
        .onAppear {
            seriesViewModel.loadSeries()
        }
        .navigationTitle("Detalles del Personaje")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    appState.state = .loadedCharacters // Regresar a la vista de personajes
                }) {
                    Image(systemName: "chevron.backward")
                }
            }
        }
    }

    // MARK: - Subviews -

    /// ScrollView horizontal para mostrar las series asociadas al personaje.
    private var seriesScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(seriesViewModel.series, id: \.id) { serie in
                    seriesCard(serie: serie)
                }
            }
            .padding()
        }
    }

    /// Vista que representa una tarjeta para cada serie.
    private func seriesCard(serie: SerieModel) -> some View {
        VStack {
            AsyncImage(url: URL(string: "\(serie.thumbnail.path).\(serie.thumbnail.thumbnailExtension)")) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 150)
            } placeholder: {
                ProgressView()
            }
            Text(serie.title)
                .font(.caption)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).stroke(Color.yellow, lineWidth: 2))
        .frame(width: 140)
        .onTapGesture {
            appState.actualCharacter = character
            appState.state = .loadingSerieDetail(serie) // Cambia el estado para cargar detalles de la serie
        }
    }
}

// MARK: - Preview -

/// Vista previa para verificar el diseño y funcionalidad de `CharacterDetailView`.
#Preview {
    let sampleCharacter = Character(
        id: 1011334,
        name: "3-D Man",
        description: "Un personaje ficticio del universo Marvel.",
        thumbnail: CharacterThumbnail(
            path: "https://via.placeholder.com/150",
            thumbnailExtension: .jpg
        )
    )
    let appState = RootViewModel.createPlaceholderInstance()

    CharacterDetailView(
        navigationPath: .constant(NavigationPath()),
        character: sampleCharacter,
        appState: appState
    )
    .environmentObject(appState)
}
