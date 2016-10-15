//
//  ParsePokedex.swift
//  Pokedex
//
//  Created by Fabio Miciano on 14/10/16.
//  Copyright © 2016 Fabio Miciano. All rights reserved.
//

import Foundation

class ParsePokedex
{
    func parseAllPokedex(response:[String: Any]?) -> PokedexModel
    {
        guard let response = response else { return PokedexModel(count: 0, next: "", previus: "", results: []) }
        
        let count = response["count"] as? Int ?? 0
        let next = response["next"] as? String ?? ""
        let previus = response["previous"] as? String ?? ""
        let results = response["results"] as? [[String: Any]] ?? []
        return PokedexModel(count: count, next: next, previus: previus, results: results)
    }
    
    func parsePokemon(response:[String: Any]?) -> PokemonModel
    {
        guard let response = response else { return PokemonModel(id: 0, name: "", urlImage: "") }
        
        let name = response["name"] as? String ?? ""
        let id = response["id"] as? Int ?? 0
        let sprites = response["sprites"] as? [String: Any]
        let urlImage = sprites?["front_default"] as? String ?? ""
        
        return PokemonModel(id: id, name: name, urlImage: urlImage)
    }
}
