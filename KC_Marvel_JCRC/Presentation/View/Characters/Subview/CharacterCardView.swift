//
//  CharacterCardView.swift
//  KC_Marvel_JCRC
//
//  Created by Juan Carlos Rubio Casas on 17/12/24.
//

import SwiftUI

// MARK: - CharacterCardView -

/// Vista de tarjeta que muestra la información básica de un personaje.
struct CharacterCardView: View {
    // MARK: - Properties -

    /// ViewModel que contiene la lógica de negocio para los personajes.
    var viewModel: CharactersViewModel

    /// URL de la imagen del personaje.
    let photo: String

    /// Nombre del personaje.
    let characterName: String

    /// Índice del personaje en la lista.
    let index: Int

    /// Altura de la tarjeta.
    let height: CGFloat

    /// Tamaño de fuente para el nombre del personaje.
    let fontSize: CGFloat

    // MARK: - Body -

    var body: some View {
        AsyncImage(url: URL(string: photo)) { phase in
            switch phase {
            case .empty:
                placeholderView
            case .success(let image):
                contentView(image: image)
            case .failure:
                errorView
            @unknown default:
                placeholderView
            }
        }
    }

    // MARK: - Placeholder View -

    /// Vista de marcador de posición que se muestra mientras se carga la imagen.
    private var placeholderView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .frame(height: height)
                .foregroundColor(.gray)
            Image(systemName: "person")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.black)
        }
    }

    // MARK: - Content View -

    /// Vista principal que se muestra cuando la imagen se carga con éxito.
    private func contentView(image: Image) -> some View {
        image
            .resizable()
            .frame(height: height)
            .cornerRadius(20)
            .overlay(contentOverlay)
    }

    // MARK: - Content Overlay -

    /// Superposición que incluye el nombre del personaje con un fondo degradado.
    private var contentOverlay: some View {
        ZStack {
            // Gradiente para resaltar el texto.
            LinearGradient(
                gradient: Gradient(colors: [.clear, .clear, .clear, .black.opacity(0.8)]),
                startPoint: .bottom, endPoint: .top
            )
            .cornerRadius(20)

            VStack {
                Spacer()
                HStack {
                    Text(characterName)
                        .font(.system(size: fontSize))
                        .foregroundColor(.white)
                        .bold()
                        .lineLimit(1)
                        .accessibilityIdentifier("CharacterName-\(index)")
                    Spacer()
                }
                .padding()
            }
        }
    }

    // MARK: - Error View -

    /// Vista que se muestra si ocurre un error al cargar la imagen.
    private var errorView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .frame(height: height)
                .foregroundColor(.red)
            Image(systemName: "xmark.circle")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(.white)
        }
    }
}

// MARK: - Preview -
/*
/// Vista previa para verificar el diseño y funcionalidad de `CharacterCardView`.
#Preview {
    CharacterCardView(
        viewModel: CharactersViewModel.sampleData(), // Método simulado para vista previa.
        photo: "https://via.placeholder.com/150",
        characterName: "Spider-Man",
        index: 0,
        height: 275,
        fontSize: 24
    )
    .padding()
}
*/
