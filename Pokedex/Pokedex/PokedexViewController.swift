//
//  PokedexViewController.swift
//  Pokedex
//
//  Created by Fabio Miciano on 14/10/16.
//  Copyright © 2016 Fabio Miciano. All rights reserved.
//

import Foundation
import UIKit

struct CellIdentifier {
    static let LoadCell = "loadCell"
    static let NormalCell = "cell"
    static let EmptyCell = "emptyCell"
}


class PokedexViewController: UITableViewController, RequestPokedexProtocol
{
    var requestPokedex: ResquestPokedex = ResquestPokedex()
    var resultModel: PokedexModel?
    var resultCount = 0
    var pokemons = [PokemonModel]()
    var imagePokemons = [UIImage]()
    
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
                self.resultCount += model.results
            case .serverError(let description):
                print(description)
            case .timeOut(let description):
                print(description)
            case .noConnection(let description):
                print(description)
            case .invalidResponse:
                print("Invalid Response")
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
                    //Adiciona o pokemon em nossa variavel
                    self.pokemons.append(model)
                    //Manda fazer load da imagem do pokemon carregado
                    self.loadImagePokemon(url: model.urlImage)
                case .serverError(let description):
                    print(description)
                case .timeOut(let description):
                    print(description)
                case .noConnection(let description):
                    print(description)
                case .invalidResponse:
                    print("Invalid Response")
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
                    //Salva a imagem em nossa variavel
                    self.imagePokemons.append(model)
                    //If inline
                    //Se o ultimo pokemon carregado ainda nao for o ultimo pokemon da lista de todos pokemons que nos temos, mandamos ele carregar o proximo pokemon
                    //Se já tiver sido carregado todos os pokemons eu mando atualizar a tabela
                    self.pokemons.last!.id < self.resultCount ?
                        self.loadPokemon(self.pokemons.last!.id + 1) :
                        self.tableView.reloadData()
                case .noConnection(let description):
                    print(description)
                case .serverError(let description):
                    print(description)
                case .downloadCanceled(_ ):
                    self.loadImagePokemon(url: url)
                case .timeOut(let description):
                    print(description)
                case .invalidResponse:
                    print("Invalid Response")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return resultModel?.next == "" ? resultCount : resultCount + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Se for a ultima célula carrego a célula de load
        if indexPath.row == resultCount {
            guard let cellLoad = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.LoadCell, for: indexPath) as? LoadViewCell else {
                return tableView.dequeueReusableCell(withIdentifier: CellIdentifier.EmptyCell, for: indexPath)
            }
            //Inicio a animação de load
            cellLoad.loadActivity.startAnimating()
            return cellLoad
        }
        
        //Se tiver tudo ok carrego a celula de pokemon
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.NormalCell, for: indexPath) as? PokemonViewCell else {
             return tableView.dequeueReusableCell(withIdentifier: CellIdentifier.EmptyCell, for: indexPath)
        }
        
        //Configuro o visual da célula
        cell.configureCell(withModel: pokemons[indexPath.row], pokemonSpriteData: imagePokemons[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        if indexPath.row == resultCount { loadPokedex(url: resultModel?.next) }
    }
}
