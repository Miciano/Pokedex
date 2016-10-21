//
//  ParsePokedex.swift
//  Pokedex
//
//  Created by Fabio Miciano on 14/10/16.
//  Copyright © 2016 Fabio Miciano. All rights reserved.
//

import Foundation

typealias ParseReponseArray = [String: Any]?
typealias PokemonSpriteArray = [String: Any]

class ParsePokedex
{
    func parseAllPokedex(response: ParseReponseArray) -> PokedexModel
    {
        guard let response = response else { return PokedexModel() }
        
        let count = response["count"] as? Int ?? 0
        let next = response["next"] as? String ?? ""
        let previus = response["previous"] as? String ?? ""
        let results = response["results"] as? PokedexResultArray ?? []
        
        return PokedexModel(count: count, next: next, previus: previus, results: results)
    }
    
    func parsePokemon(response: ParseReponseArray) -> PokemonModel
    {
        guard let response = response else { return PokemonModel() }
        
        let name = response["name"] as? String ?? ""
        let id = response["id"] as? Int ?? 0
        let sprites = response["sprites"] as? PokemonSpriteArray
        let urlImage = sprites?["front_default"] as? String ?? ""
        
        return PokemonModel(id: id, name: name, urlImage: urlImage)
    }
}
