//
//  NetworkSeries.swift
//  KC_Marvel_JCRC
//
//  Created by Juan Carlos Rubio Casas on 20/12/24.
//

import Foundation

// MARK: - NetworkSeriesProtocol

/// Protocolo que define las operaciones relacionadas con la obtención de series desde una red o API.
protocol NetworkSeriesProtocol {
    
    /// Recupera una lista de series desde la red.
    /// - Returns: Una lista de objetos `SerieModel`.
    func getSeries() async -> [SerieModel]
}
