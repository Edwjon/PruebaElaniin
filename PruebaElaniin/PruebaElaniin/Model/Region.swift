//
//  Region.swift
//  PruebaElaniin
//
//  Created by Edward Pizzurro on 1/14/23.
//

import Foundation

struct Region: Codable {
    let name: String
    let pokedexes: [Pokedex]
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case pokedexes = "pokedexes"
    }
}
