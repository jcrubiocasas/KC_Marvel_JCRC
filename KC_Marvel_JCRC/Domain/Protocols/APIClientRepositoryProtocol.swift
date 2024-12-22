//
//  APIClientRepositoryProtocol.swift
//  KC_Marvel_JCRC
//
//  Created by Juan Carlos Rubio Casas on 17/12/24.
//

import Foundation

// MARK: - APIClientRepositoryProtocol -
protocol APIClientRepositoryProtocol {
    func getCharacter(by characterName: String, apiRouter: APIRouter) async throws -> Character
    func getSeries(by characterId: Int, apiRouter: APIRouter) async throws -> Series
    //func getSeries(by characterId: Int, apiRouter: APIRouter) async throws -> SeriesAPI
}
