//
//  PokedexModel.swift
//  Pokedex
//
//  Created by Fabio Miciano on 14/10/16.
//  Copyright © 2016 Fabio Miciano. All rights reserved.
//

import Foundation

//Apelido para tipos [[String: Any]]
typealias PokedexResultArray = [[String : Any]]

struct PokedexModel
{
    let count: Int
    let next: String
    let previus: String
    let results: Int
}

extension PokedexModel
{
    init() {
        self.count = 0
        self.next = ""
        self.previus = ""
        self.results = 0
    }
}
