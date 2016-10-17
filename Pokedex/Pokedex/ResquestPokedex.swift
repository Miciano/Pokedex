//
//  ResquestPokedex.swift
//  Pokedex
//
//  Created by Fabio Miciano on 14/10/16.
//  Copyright © 2016 Fabio Miciano. All rights reserved.
//

import Foundation
import Alamofire

struct PokemonAPIUrl {
    static let Main: String = "http://pokeapi.co/api/v2/pokemon/"
}

typealias PokedexCompletion = (_ response: PokedexResponse) -> Void
typealias PokemonCompletion = (_ response: PokemonResponse) -> Void
typealias PokedexImageCompletion = (_ response: ImageResponse) -> Void

class ResquestPokedex
{
    let alamofireManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10000
        configuration.timeoutIntervalForResource = 10000
        return SessionManager(configuration: configuration);
    }()
    
    let parse: ParsePokedex = ParsePokedex()
    
    func getAllPokemons(url:String?, completion:@escaping PokedexCompletion)
    {
        let page = url == "" || url == nil ? PokemonAPIUrl.Main : url!
        
        alamofireManager.request(page, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON
        { (response) in
            
            let statusCode = response.response?.statusCode
            switch response.result
            {
                case .success(let value):
                    let resultValue = value as? [String: Any]
                    if statusCode == 404
                    {
                        if let description = resultValue?["detail"] as? String
                        {
                            let error = ServerError(description: description, errorCode: statusCode!)
                            completion(.serverError(description: error))
                        }
                    }
                    else if statusCode == 200
                    {
                        let model = self.parse.parseAllPokedex(response: resultValue)
                        completion(.success(model: model))
                    }
                case .failure(let error):
                    let errorCode = error._code
                    if errorCode == -1009
                    {
                        let erro = ServerError(description: error.localizedDescription, errorCode: errorCode)
                        completion(.noConnection(description: erro))
                    }
                    else if errorCode == -1001
                    {
                        let erro = ServerError(description: error.localizedDescription, errorCode: errorCode)
                        completion(.timeOut(description: erro))
                    }
            }
        }
    }
    
    func getPokemon(id:Int?, completion:@escaping PokemonCompletion)
    {
        guard let id = id else { return }
        alamofireManager.request("\(PokemonAPIUrl.Main)\(id)/", method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON
        { (response) in
            
            let statusCode = response.response?.statusCode
            switch response.result
            {
                case .success(let value):
                    let resultValue = value as? [String: Any]
                    if statusCode == 404
                    {
                        if let description = resultValue?["detail"] as? String
                        {
                            let error = ServerError(description: description, errorCode: statusCode!)
                            completion(.serverError(description: error))
                        }
                    }
                    else if statusCode == 200
                    {
                        let model = self.parse.parsePokemon(response: resultValue)
                        completion(.success(model: model))
                    }
                case .failure(let error):
                    let errorCode = error._code
                    if errorCode == -1009
                    {
                        let erro = ServerError(description: error.localizedDescription, errorCode: errorCode)
                        completion(.noConnection(description: erro))
                    }
                    else if errorCode == -1001
                    {
                        let erro = ServerError(description: error.localizedDescription, errorCode: errorCode)
                        completion(.timeOut(description: erro))
                    }
            }
        }
    }
    
    func getImagePokemon(url:String, completion:@escaping PokedexImageCompletion)
    {
        alamofireManager.request(url, method: .get).responseData
        { (response) in
            
            if response.response?.statusCode == 200
            {
                guard let data = response.data else
                {
                    let erro = ServerError(description: "Falha no Download, data vazio", errorCode: 404)
                    completion(.serverError(description: erro))
                    return
                }
                completion(ImageResponse.success(model: data))
            }
        }
    }
}
