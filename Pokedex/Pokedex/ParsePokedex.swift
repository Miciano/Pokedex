//
//  ParsePokedex.swift
//  Pokedex
//
//  Created by Fabio Miciano on 14/10/16.
//  Copyright © 2016 Fabio Miciano. All rights reserved.
//

import Foundation

typealias ParseReponseDict = [String: Any]
typealias PokemonSpriteDict = [String: Any]

class ParsePokedex
{
    func parseAllPokedex(response: ParseReponseDict) -> PokedexModel?
    {
        guard let count = response["count"] as? Int,
            let resultsList = response["results"] as? [[String: Any]] //Pego a lista de resultado
        else {
            return nil
        }
        
        let next = response["next"] as? String ?? ""
        let previus = response["previous"] as? String ?? ""
        //Pego o numero de filhos da lista de resultados
        let results = resultsList.count
        
        return PokedexModel(count: count, next: next, previus: previus, results: results)
    }
    
    func parsePokemon(response: ParseReponseDict) -> PokemonModel?
    {
        guard let name = response["name"] as? String,
            let id = response["id"] as? Int,
            let sprites = response["sprites"] as? PokemonSpriteDict,
            let urlImage = sprites["front_default"] as? String
        else {
            return nil
        }
        
        return PokemonModel(id: id, name: name, urlImage: urlImage)
    }
}
