//
//  NetworkManager.swift
//  PruebaElaniin
//
//  Created by Edward Pizzurro on 1/16/23.
//

import Foundation

enum Endpoints : String {
    case region = "region"
    case pokedex = "pokedex"
    case pokemon = "pokemon"
}

class NetworkManager {
    private let baseURL = "https://pokeapi.co/api/v2/"
    
    public func get<T>(
        id: Int?,
        name: String?,
        endPoint: String,
        completion: @escaping (Result<T, Error>) -> ()
    ) where T: Codable {
        
        var urlString: String!
        if let id = id {
            urlString = baseURL + "\(endPoint)/\(id)"
        } else if let name = name {
            urlString = baseURL + "\(endPoint)/\(name)"
        } else {
            completion(.failure(CustomError.missingIDorName))
            return
        }
        
        guard let url = URL(string: urlString) else {
            completion(.failure(CustomError.invalidURL(url: urlString)))
            return
        }
        
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, _ ,error in
            if let error = error {
                completion(.failure(CustomError.other(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(CustomError.missingData))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                completion(.success(result))
            } catch let error {
                completion(.failure(CustomError.decodingError(error)))
            }
        }
        task.resume()
    }
}
