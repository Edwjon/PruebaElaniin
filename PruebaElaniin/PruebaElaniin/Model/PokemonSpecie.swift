//
//  PokemonSpecie.swift
//  PruebaElaniin
//
//  Created by Edward Pizzurro on 1/14/23.
//

import Foundation

struct PokemonSpecie: Codable {
    let name: String
    let varieties: [PokemonSpeciesVariety]?
    
    enum CodingKeys: String, CodingKey {
        case varieties = "varieties"
        case name = "name"
    }
}
