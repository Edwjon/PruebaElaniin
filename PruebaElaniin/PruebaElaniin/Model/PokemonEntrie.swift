//
//  PokemonEntrie.swift
//  PruebaElaniin
//
//  Created by Edward Pizzurro on 1/14/23.
//

import Foundation

struct PokemonEntrie: Codable {
    let pokemon_species: PokemonSpecie
    
    enum CodingKeys: String, CodingKey {
        case pokemon_species = "pokemon_species"
    }
}
