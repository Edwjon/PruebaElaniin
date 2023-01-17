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
    
    //MARK: - Get Product from Network
    public func get<T>(
        id: Int?,
        name: String?,
        endPoint: String,
        completion: @escaping (Result<T, Error>) -> ()
    ) where T: Codable {
        var url: URL!
        if let _ = id {
            url = URL(string: baseURL + "\(endPoint)/\(id!)")!
        } else if let _ = name {
            url = URL(string: baseURL + "\(endPoint)/\(name!)")!
        }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, _ ,error in
            if let data = data {
                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(result))
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}
