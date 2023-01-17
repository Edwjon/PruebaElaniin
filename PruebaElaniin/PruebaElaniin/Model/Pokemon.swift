//
//  Pokemon.swift
//  PruebaElaniin
//
//  Created by Edward Pizzurro on 1/14/23.
//

import Foundation
import UIKit

struct Pokemon: Codable {
    let name: String
    let height: Int?
    let weight: Int?
    let species: PokemonSpecie?
    let specie: String?
    let sprites: Sprite?
    let imageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case height = "height"
        case weight = "weight"
        case species = "species"
        case sprites = "sprites"
        case imageURL = "imageURL"
        case specie = "specie"
    }
    
    struct Sprite: Codable {
        let front_default: String?
        
        enum CodingKeys: String, CodingKey {
            case front_default = "front_default"
        }
    }
}
