//
//  PokedexResponse.swift
//  Pokedex
//
//  Created by Fabio Miciano on 14/10/16.
//  Copyright © 2016 Fabio Miciano. All rights reserved.
//

import Foundation

enum PokedexResponse
{
    case success(model: PokedexModel)
    case serverError(description: ServerError)
    case timeOut(description: ServerError)
    case noConnection(description: ServerError)
}

enum PokemonResponse
{
    case success(model: PokemonModel)
    case serverError(description: ServerError)
    case timeOut(description: ServerError)
    case noConnection(description: ServerError)
}

enum ImageResponse
{
    case success(model: Data)
    case serverError(description: ServerError)
    case timeOut(description: ServerError)
    case noConnection(description: ServerError)
}
