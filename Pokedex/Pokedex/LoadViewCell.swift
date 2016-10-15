//
//  LoadViewCell.swift
//  Pokedex
//
//  Created by Fabio Miciano on 15/10/16.
//  Copyright © 2016 Fabio Miciano. All rights reserved.
//

import Foundation
import UIKit

class LoadViewCell: UITableViewCell
{
    @IBOutlet weak var loadActivity: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        loadActivity.startAnimating()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
