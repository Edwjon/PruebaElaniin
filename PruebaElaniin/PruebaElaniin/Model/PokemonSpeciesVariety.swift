//
//  PokemonSpeciesVariety.swift
//  PruebaElaniin
//
//  Created by Edward Pizzurro on 1/14/23.
//

import Foundation

struct PokemonSpeciesVariety: Codable {
    let pokemon: Pokemon
    
    enum CodingKeys: String, CodingKey {
        case pokemon = "pokemon"
    }
}
