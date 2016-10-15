//
//  ResquestPokedex.swift
//  Pokedex
//
//  Created by Fabio Miciano on 14/10/16.
//  Copyright © 2016 Fabio Miciano. All rights reserved.
//

import Foundation
import Alamofire

class ResquestPokedex
{
    let API_URL = "http://pokeapi.co/api/v2/pokemon/"
    let alamofireManager: SessionManager?
    let parse: ParsePokedex = ParsePokedex()
    
    init()
    {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10000
        configuration.timeoutIntervalForResource = 10000
        alamofireManager = SessionManager(configuration: configuration)
    }
    
    func getAllPokemons(url:String?, completion:@escaping (_ response: PokedexResponse)->Void)
    {
        let page = url == "" || url == nil ? API_URL : url!
        alamofireManager?.request(page, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON
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
    
    func getPokemon(id:Int?, completion:@escaping (_ response: PokemonResponse) -> Void)
    {
        guard let id = id else { return }
        alamofireManager?.request("\(API_URL)\(id)/", method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON
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
    
    func getImagePokemon(url:String, completion:@escaping (_ response: ImageResponse)->Void)
    {
        alamofireManager?.request(url, method: .get).responseData
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
