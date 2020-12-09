//
//  Pokemon.swift
//  Pokedex
//
//  Created by Feng (Jeffrey) Lu on 7/4/20.
//  Copyright © 2020 CS50. All rights reserved.
//

import Foundation

struct PokemonList: Codable{
    let results: [Pokemon]
}

struct Pokemon: Codable{
    let name: String
    let url: String
}

struct PokemonData: Codable{
    let id: Int
    let types: [PokemonTypeEntry]
    let sprites: sprite
}

struct sprite: Codable{
    let front_default: String
}


struct PokemonTypeEntry: Codable{
    let slot: Int
    let type: PokemonType
}

struct PokemonType: Codable{
    let name: String
    let url: String
}

struct Description: Codable{
    let flavor_text_entries: [PokemonFlavorTypes]
}

struct PokemonFlavorTypes: Codable{
    let flavor_text: String
    let language: Language
}

struct Language: Codable{
    let name: String
    let url: String
}


