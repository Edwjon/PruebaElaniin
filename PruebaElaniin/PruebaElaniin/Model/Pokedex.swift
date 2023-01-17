//
//  Pokedex.swift
//  PruebaElaniin
//
//  Created by Edward Pizzurro on 1/14/23.
//

import Foundation

struct Pokedex: Codable {
    let name: String
    let pokemon_entries: [PokemonEntrie]?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case pokemon_entries = "pokemon_entries"
    }
}
