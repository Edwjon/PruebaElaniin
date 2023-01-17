//
//  PokemonViewController.swift
//  PruebaElaniin
//
//  Created by Edward Pizzurro on 1/13/23.
//

import Foundation
import UIKit

class PokemonViewController: UIViewController {
    
    let avatarImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()
    
    let heightLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()
    
    let weightLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()
    
    let specieLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()
    
    private let networkManager = NetworkManager()
    var pokemonName: String!
    var pokemon: Pokemon!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupNavigationBarButtonItems()
        apiCalls()
    }
    
    @objc func addPokemonToArray() {
        
        for i in pokemones {
            if i.name == self.pokemon.name {
                let alert = Utils().createAlertController(title: "Error", message: "This pokemon is already in your team", actionTitle: "Ok", withAction: true)
                self.present(alert, animated: true, completion: nil)
                return
            }
        }
        
        if pokemones.count == 6 {
            let alert = Utils().createAlertController(title: "Error", message: "Your team has reached its limit", actionTitle: "Ok", withAction: true)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let alert = Utils().createAlertController(title: "Add Pokemon", message: "Are you sure you want to add this pokemon to your current team?", actionTitle: "Yes", withAction: false)
        alert.addAction(UIAlertAction(title: "Yes", style: .default) { action -> Void in
            pokemones.append(self.pokemon)
        })
        alert.addAction(UIAlertAction(title: "No", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.avatarImage.image = UIImage(data: data)
            }
        }
    }
    
}


//MARK: - Setup Methods -
extension PokemonViewController {
    func setupUI() {
        view.backgroundColor = .white
        title = "Pokemon"
        
        view.addSubview(avatarImage)
        avatarImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
        avatarImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        avatarImage.widthAnchor.constraint(equalToConstant: 150).isActive = true
        avatarImage.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        view.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: avatarImage.topAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: avatarImage.rightAnchor, constant: 20).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        view.addSubview(weightLabel)
        weightLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10).isActive = true
        weightLabel.leftAnchor.constraint(equalTo: avatarImage.rightAnchor, constant: 20).isActive = true
        weightLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        weightLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        view.addSubview(heightLabel)
        heightLabel.topAnchor.constraint(equalTo: weightLabel.bottomAnchor, constant: 10).isActive = true
        heightLabel.leftAnchor.constraint(equalTo: avatarImage.rightAnchor, constant: 20).isActive = true
        heightLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        heightLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        view.addSubview(specieLabel)
        specieLabel.topAnchor.constraint(equalTo: heightLabel.bottomAnchor, constant: 10).isActive = true
        specieLabel.leftAnchor.constraint(equalTo: avatarImage.rightAnchor, constant: 20).isActive = true
        specieLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        specieLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    func setupInfo(pokemon: Pokemon) {
        nameLabel.text = "Name: \(pokemon.name)"
        weightLabel.text = "Weight: \(pokemon.weight ?? 0)"
        heightLabel.text = "Height: \(pokemon.height ?? 0)"
        specieLabel.text = "Specie: \(pokemon.species?.name ?? "No info")"
        
        if let url = pokemon.sprites?.front_default {
            downloadImage(from: URL(string: url)!)
        } else {
            avatarImage.image = UIImage(named: "defaultAvatar")
        }
    }
    
    func setupNavigationBarButtonItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+ to team", style: .plain, target: self, action: #selector(addPokemonToArray))
    }
}


//MARK: - API Calls -
extension PokemonViewController {
    func apiCalls() {
        networkManager.get(id: nil, name: pokemonName, endPoint: Endpoints.pokemon.rawValue) { (result: Result<Pokemon,Error>) in
            switch result {
            case .success(let pokemon):
                DispatchQueue.main.async {
                    self.pokemon = pokemon
                    self.setupInfo(pokemon: pokemon)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
