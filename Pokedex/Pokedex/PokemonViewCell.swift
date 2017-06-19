//
//  PokemonViewCell.swift
//  Pokedex
//
//  Created by Fabio Miciano on 14/10/16.
//  Copyright © 2016 Fabio Miciano. All rights reserved.
//

import Foundation
import UIKit

class PokemonViewCell: UITableViewCell
{
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var pokemonIdLb: UILabel!
    @IBOutlet weak var pokemonNameLb: UILabel!
    
    public func configureCell(withModel model: PokemonModel, pokemonSpriteData data: UIImage) {
        self.pokemonIdLb.text = "#\(model.id)"
        self.pokemonNameLb.text = model.name
        self.imgView.image = data
    }
}
