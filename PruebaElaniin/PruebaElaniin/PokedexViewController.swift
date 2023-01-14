//
//  ListPokemonViewController.swift
//  PruebaElaniin
//
//  Created by Edward Pizzurro on 1/12/23.
//

import Foundation
import UIKit

class PokedexViewController: UIViewController {
    
    private let networkManager = NetworkManager()
    var region: Region!
    
    lazy var collectionView: UICollectionView = {
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .vertical
        collectionLayout.minimumInteritemSpacing = 0
        collectionLayout.minimumLineSpacing = 30
        let v = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        v.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: "pokedexCell")
        v.translatesAutoresizingMaskIntoConstraints = false
        v.dataSource = self
        v.delegate = self
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        title = "Pokedex"
        
        setupUI()
    }
    
    func setupUI() {
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
}

extension PokedexViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.region.pokedexes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pokedexCell", for: indexPath) as! MainCollectionViewCell
        cell.configure(title: region.pokedexes[indexPath.item].name, image: "pokedexIcon")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pokedex = region.pokedexes[indexPath.item]
        let vc = CategoriasViewController()
        vc.pokedexName = pokedex.name
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

class NetworkManager {
    //MARK: - Get Product from Network
    public func getRegions(
        id: Int,
        completion: @escaping (Result<Region, Error>) -> ()
    )  {
        let url = URL(string: "https://pokeapi.co/api/v2/region/\(id)")!
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, _ ,error in
            if let data = data {
                do {
                    let result = try JSONDecoder().decode(Region.self, from: data)
                    completion(.success(result))
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    public func getPokedex(
        name: String,
        completion: @escaping (Result<Pokedex, Error>) -> ()
    )  {
        let url = URL(string: "https://pokeapi.co/api/v2/pokedex/\(name)")!
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, _ ,error in
            if let data = data {
                do {
                    let result = try JSONDecoder().decode(Pokedex.self, from: data)
                    completion(.success(result))
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    public func getSpecie(
        name: String,
        completion: @escaping (Result<PokemonSpecie, Error>) -> ()
    )  {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon-species/\(name)")!
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, _ ,error in
            if let data = data {
                do {
                    let result = try JSONDecoder().decode(PokemonSpecie.self, from: data)
                    completion(.success(result))
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    public func getPokemon(
        name: String,
        completion: @escaping (Result<Pokemon, Error>) -> ()
    )  {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(name)")!
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, _ ,error in
            if let data = data {
                do {
                    let result = try JSONDecoder().decode(Pokemon.self, from: data)
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


struct Region: Codable {
    let name: String
    let pokedexes: [Pokedex]
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case pokedexes = "pokedexes"
    }
}

struct Pokedex: Codable {
    let name: String
    let pokemon_entries: [PokemonEntrie]?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case pokemon_entries = "pokemon_entries"
    }
}

struct PokemonEntrie: Codable {
    let pokemon_species: PokemonSpecie
    
    enum CodingKeys: String, CodingKey {
        case pokemon_species = "pokemon_species"
    }
}

struct PokemonSpecie: Codable {
    let name: String
    let varieties: [PokemonSpeciesVariety]?
    
    enum CodingKeys: String, CodingKey {
        case varieties = "varieties"
        case name = "name"
    }
}

struct PokemonSpeciesVariety: Codable {
    let pokemon: Pokemon
    
    enum CodingKeys: String, CodingKey {
        case pokemon = "pokemon"
    }
}

struct Pokemon: Codable {
    let name: String
    let height: Int?
    let weight: Int?
    let species: PokemonSpecie?
    let specie: String?
    let sprites: Sprite?
    let imageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case height = "height"
        case weight = "weight"
        case species = "species"
        case sprites = "sprites"
        case imageURL = "imageURL"
        case specie = "specie"
    }
    
    struct Sprite: Codable {
        let front_default: String?
        
        enum CodingKeys: String, CodingKey {
            case front_default = "front_default"
        }
    }
}
