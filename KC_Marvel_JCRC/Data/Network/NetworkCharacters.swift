//
//  NetworkCharacters.swift
//  KC_Marvel_JCRC
//
//  Created by Juan Carlos Rubio Casas on 15/12/24.
//

import Foundation

// MARK: - NetworkCharactersProtocol

/// Protocolo que define las operaciones relacionadas con la obtención de personajes desde una red o API.
protocol NetworkCharactersProtocol {
    
    /// Recupera una lista de personajes desde la red.
    /// - Returns: Una lista de objetos `Character`.
    func getCharacters() async -> [Character]
}
