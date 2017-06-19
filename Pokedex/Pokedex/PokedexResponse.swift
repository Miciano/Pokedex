//
//  PokedexResponse.swift
//  Pokedex
//
//  Created by Fabio Miciano on 14/10/16.
//  Copyright © 2016 Fabio Miciano. All rights reserved.
//

import Foundation
import UIKit

enum PokedexResponse
{
    case success(model: PokedexModel)
    case serverError(description: ServerError)
    case timeOut(description: ServerError)
    case noConnection(description: ServerError)
    case invalidResponse
}

enum PokemonResponse
{
    case success(model: PokemonModel)
    case serverError(description: ServerError)
    case timeOut(description: ServerError)
    case noConnection(description: ServerError)
    case invalidResponse
}

enum ImageResponse {
    case success(model: UIImage)
    case serverError(description: ServerError)
    case timeOut(description: ServerError)
    case noConnection(description: ServerError)
    case downloadCanceled(description: ServerError)
    case invalidResponse
}
