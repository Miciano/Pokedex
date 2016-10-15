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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
