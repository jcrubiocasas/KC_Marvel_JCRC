//
//  SerieDetailView.swift
//  KC_Marvel_JCRC
//
//  Created by Juan Carlos Rubio Casas on 21/12/24.
//

import SwiftUI

// MARK: - SerieDetailView -

/// Vista que muestra los detalles de una serie específica.
struct SerieDetailView: View {
    // MARK: - Properties -

    /// Ruta de navegación, para gestionar la navegación entre vistas.
    @Binding var navigationPath: NavigationPath

    /// Serie cuyos detalles se mostrarán.
    let serie: SerieModel

    /// Modelo del estado global de la aplicación.
    @EnvironmentObject var appState: RootViewModel

    // MARK: - Initializer -

    init(
        navigationPath: Binding<NavigationPath>,
        serie: SerieModel,
        appState: RootViewModel
    ) {
        self._navigationPath = navigationPath // Inicializa el @Binding correctamente.
        self.serie = serie
    }

    // MARK: - Body -

    var body: some View {
        VStack {
            // Título de la serie
            Text(serie.title)
                .font(.title)
                .bold()
                .padding()

            // Imagen de la serie
            AsyncImage(url: URL(string: "\(serie.thumbnail.path).\(serie.thumbnail.thumbnailExtension)")) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
            } placeholder: {
                ProgressView()
            }

            // Descripción de la serie
            if let description = serie.description {
                Text(description)
                    .padding()
            } else {
                Text("Sin descripción disponible")
                    .italic()
                    .foregroundColor(.gray)
                    .padding()
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Detalles de la Serie")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    appState.state = .loadingSeries(appState.actualCharacter!) // Regresar a las series del personaje.
                }) {
                    Image(systemName: "chevron.backward")
                }
            }
        }
    }
}

// MARK: - Preview -

/// Vista previa para verificar el diseño y funcionalidad de `SerieDetailView`.
#Preview {
    let appState = configureAppState()

    SerieDetailView(
        navigationPath: .constant(NavigationPath()),
        serie: SerieModel(
            id: 101,
            title: "Serie de Ejemplo",
            description: "Esta es una descripción de ejemplo para una serie.",
            thumbnail: SerieThumbnail(
                path: "https://via.placeholder.com/150",
                thumbnailExtension: "jpg"
            ),
            characterId: 1
        ),
        appState: appState
    )
    .environmentObject(appState)
}

/// Configuración de un estado de ejemplo para la vista previa.
@MainActor
private func configureAppState() -> RootViewModel {
    let appState = RootViewModel.createPlaceholderInstance()
    appState.actualCharacter = Character(
        id: 1011334,
        name: "3-D Man",
        description: "Un personaje ficticio del universo Marvel.",
        thumbnail: CharacterThumbnail(
            path: "https://via.placeholder.com/150",
            thumbnailExtension: .jpg
        )
    )
    return appState
}
