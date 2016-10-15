//
//  PokedexViewController.swift
//  Pokedex
//
//  Created by Fabio Miciano on 14/10/16.
//  Copyright © 2016 Fabio Miciano. All rights reserved.
//

import Foundation
import UIKit

class PokedexViewController: UITableViewController, RequestPokedexProtocol
{
    var requestPokedex: ResquestPokedex = ResquestPokedex()
    var resultModel: PokedexModel?
    var resultCount = 0
    var pokemons = [PokemonModel]()
    var imagePokemons = [Data]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    fileprivate func loadPokedex(url: String?)
    {
        requestPokedex.getAllPokemons(url: url)
        { (response) in
            
            switch response
            {
            case .success(let model):
                self.resultModel = model
                self.loadPokemon(self.resultCount+1)
                self.resultCount += model.results.count
            case .serverError(let description):
                print(description)
            case .timeOut(let description):
                print(description)
            case .noConnection(let description):
                print(description)
            }
        }
    }
    
    fileprivate func loadPokemon(_ id: Int)
    {
        requestPokedex.getPokemon(id: id)
        { (response) in
            
            switch response
            {
                case .success(let model):
                    self.pokemons.append(model)
                    self.loadImagePokemon(url: model.urlImage)
                case .serverError(let description):
                    print(description)
                case .timeOut(let description):
                    print(description)
                case .noConnection(let description):
                    print(description)
            }
        }
    }
    
    fileprivate func loadImagePokemon(url: String)
    {
        requestPokedex.getImagePokemon(url: url)
        { (response) in
            
            switch response
            {
                case .success(let model):
                    self.imagePokemons.append(model)
                    if self.pokemons.last!.id < self.resultCount
                    { self.loadPokemon(self.pokemons.last!.id+1) }
                    else
                    { self.tableView.reloadData() }
                case .noConnection(let description):
                    print(description)
                case .serverError(let description):
                    print(description)
                case .timeOut(let description):
                    print(description)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if resultModel?.next == "" { return resultCount }
        return resultCount+1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row == resultCount
        { return tableView.dequeueReusableCell(withIdentifier: "loadCell", for: indexPath) }
        else
        {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PokemonViewCell
            {
                cell.pokemonIdLb.text = "#\(pokemons[indexPath.row].id)"
                cell.pokemonNameLb.text = pokemons[indexPath.row].name
                cell.imgView.image = UIImage(data: imagePokemons[indexPath.row])
                return cell
            }
        }
        
        return tableView.dequeueReusableCell(withIdentifier: "emptyCell")!
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        if indexPath.row == resultCount { loadPokedex(url: resultModel?.next) }
    }
}
