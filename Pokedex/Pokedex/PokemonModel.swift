//
//  PokemonModel.swift
//  Pokedex
//
//  Created by Fabio Miciano on 14/10/16.
//  Copyright © 2016 Fabio Miciano. All rights reserved.
//

import Foundation

struct PokemonModel
{
    var id: Int
    var name: String
    var urlImage: String
}

extension PokemonModel
{
    init()
    {
        self.id = 0
        self.name = ""
        self.urlImage = ""
    }
}
