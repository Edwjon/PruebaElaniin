//
//  CategoriasViewController.swift
//  PruebaElaniin
//
//  Created by Edward Pizzurro on 1/13/23.
//

import Foundation
import UIKit
import FirebaseFirestore

var pokemones: [Pokemon] = []

class CategoriasViewController: UIViewController {
    
    private let networkManager = NetworkManager()
    var pokedexName: String!
    var pokedexEntries: [PokemonEntrie] = []
    var teamPokemones: [Pokemon] = []
    
    lazy var collectionView: UICollectionView = {
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .vertical
        collectionLayout.minimumInteritemSpacing = 0
        collectionLayout.minimumLineSpacing = 30
        let v = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        v.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: "categoriasCell")
        v.translatesAutoresizingMaskIntoConstraints = false
        v.dataSource = self
        v.delegate = self
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        apiCalls()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigationBarButton()
    }
}


//MARK: - Setup -
extension CategoriasViewController {
    func setupUI() {
        view.backgroundColor = .white
        title = "Pokemones"
        
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func setupNavigationBarButton() {
        if pokemones.isEmpty {
            navigationItem.setHidesBackButton(false, animated: false)
        } else {
            navigationItem.setHidesBackButton(true, animated: false)
        }
        
        if pokemones.count > 0 {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Finish team", style: .plain, target: self, action: #selector(addPokemonToTeam))
        }
    }
}


//MARK: - Pokemon Auxiliar Methods -
extension CategoriasViewController {
    @objc func addPokemonToTeam() {
        if pokemones.count < 3 {
            let alert = Utils().createAlertController(title: "Error", message: "You need at least 3 pokemones to finish your team. You currently have \(pokemones.count).", actionTitle: "Ok", withAction: true)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let db = Firestore.firestore()
        let id = Utils().randomString(length: 7)
        db.collection("teams").document(id).setData(
            [
                "pokemones": createPokemonDictionary()
            ]
        )
        pokemones = []
        navigationItem.setHidesBackButton(false, animated: false)
        
        let alert = Utils().createAlertController(title: "Congratulations!", message: "You have created a pokemon team! You can ckeck it out in the home page!", actionTitle: "Nice", withAction: true)
        self.present(alert, animated: true)
    }
    
    func createPokemonDictionary() -> Dictionary<String, Any> {
        let email = UserDefaults.standard.value(forKey: "email")
        var generalDictionary: [String:Any] = [:]
        var dictionary: [String:Any] = [:]
        for (index,pokemon) in pokemones.enumerated() {
            dictionary["email"] = email
            dictionary["name"] = "\(pokemon.name)"
            dictionary["weight"] = "\(pokemon.weight ?? 0)"
            dictionary["height"] = "\(pokemon.height ?? 0)"
            dictionary["specie"] = "\(pokemon.species?.name ?? "No info")"
            dictionary["imageURL"] = "\(pokemon.sprites?.front_default ?? "defaultAvatar")"
            
            generalDictionary["pokemones\(index)"] = dictionary
        }
        
        return generalDictionary
    }
}


//MARK: - API Calls -
extension CategoriasViewController {
    func apiCalls() {
        if teamPokemones.isEmpty {
            networkManager.get(id: nil, name: pokedexName, endPoint: Endpoints.pokedex.rawValue) { (result: Result<Pokedex,Error>) in
                switch result {
                case .success(let pokedex):
                    /// if the data is retrieved
                    DispatchQueue.main.async {
                        self.pokedexEntries = pokedex.pokemon_entries ?? []
                        self.collectionView.reloadData()
                    }
                case .failure(let error):
                    // if not
                    print(error.localizedDescription)
                }
            }
        }
    }
}


//MARK: - Collection View Methods -
extension CategoriasViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return teamPokemones.isEmpty ? pokedexEntries.count : teamPokemones.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoriasCell", for: indexPath) as! MainCollectionViewCell
        if teamPokemones.isEmpty {
            cell.configure(title: pokedexEntries[indexPath.item].pokemon_species.name, image: "specieIcon")
        } else {
            cell.configure(title: teamPokemones[indexPath.item].name, image: "specieIcon")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if teamPokemones.isEmpty {
            let pokemon = pokedexEntries[indexPath.item].pokemon_species.name
            let vc = PokemonViewController()
            vc.pokemonName = pokemon
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let pokemon = teamPokemones[indexPath.item].name
            let vc = PokemonViewController()
            vc.pokemonName = pokemon
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}
