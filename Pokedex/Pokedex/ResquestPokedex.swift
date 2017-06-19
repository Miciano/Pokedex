//
//  ResquestPokedex.swift
//  Pokedex
//
//  Created by Fabio Miciano on 14/10/16.
//  Copyright © 2016 Fabio Miciano. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

struct PokemonAPIURL {
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
        return SessionManager(configuration: configuration)
    }()
    
    let parse: ParsePokedex = ParsePokedex()
    
    init() {
        Alamofire.DataRequest.addAcceptableImageContentTypes(["image/jpg", "image/png", "image/jpeg"])
    }
    
    func getAllPokemons(url:String?, completion:@escaping PokedexCompletion)
    {
        let page = url == "" || url == nil ? PokemonAPIURL.Main : url!
        
        alamofireManager.request(page, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON
        { (response) in
            
            //Pega o status
            let statusCode = response.response?.statusCode
            switch response.result
            {
                //Status de erro ou sucesso
                case .success(let value):
                    //Json com retorno
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
                        if let dict = resultValue, let model = self.parse.parseAllPokedex(response: dict) {
                            completion(.success(model: model))
                        } else {
                            completion(.invalidResponse)
                        }
                    }
                case .failure(let error):
                    //Status de erro
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
        alamofireManager.request("\(PokemonAPIURL.Main)\(id)/", method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON
        { (response) in
            
            switch response.result
            {
                case .success(let value):
                    let resultValue = value as? [String: Any]
                    switch response.response?.statusCode ?? 0 {
                    case 404:
                        if let description = resultValue?["detail"] as? String
                        {
                            let error = ServerError(description: description, errorCode: 404)
                            completion(.serverError(description: error))
                        }
                    case 200:
                        if let dict = resultValue,
                            let model = self.parse.parsePokemon(response: dict) {
                            completion(.success(model: model))
                        } else {
                            completion(.invalidResponse)
                        }
                    default:
                        completion(.invalidResponse)
                    }
                case .failure(let error):
                    switch error._code {
                    case -1009 :
                        let erro = ServerError(description: error.localizedDescription, errorCode: -1009)
                        completion(.noConnection(description: erro))
                    case -1001:
                        let erro = ServerError(description: error.localizedDescription, errorCode: -1001)
                        completion(.timeOut(description: erro))
                    default:
                        completion(.invalidResponse)
                    }
            }
        }
    }
    
    func getImagePokemon(url:String, completion:@escaping PokedexImageCompletion) {
        
        let imgView = UIImageView()
        guard let urlRequest = URL(string: url) else { return }
        
        imgView.af_setImage(withURL: urlRequest, placeholderImage: nil, filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: UIImageView.ImageTransition.noTransition, runImageTransitionIfCached: true){ (response) in
            
            switch response.result {
            case .success(let value):
                //A variavel 'value' já vem no tipo UIImage
                completion(.success(model: value))
            case .failure(let error):
                let errorCode = error._code
                if errorCode == -999 || errorCode == 0 {
                    let erro = ServerError(description: response.result.error.debugDescription, errorCode: errorCode)
                    //é possivel e comum que o Alamofire cancele o download da imagem, por isso criamos um case do response novo chamado 'downloadCanceled
                    completion(.downloadCanceled(description: erro))
                }
            }
        }
    }
}
