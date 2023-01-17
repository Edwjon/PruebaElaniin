//
//  TeamsCollectionView.swift
//  PruebaElaniin
//
//  Created by Edward Pizzurro on 1/14/23.
//

import Foundation
import UIKit
import GoogleSignIn
import FirebaseAuth
import Firebase
import FirebaseFirestore
import FacebookLogin

class TeamsCollectionView: UIViewController {
    
    private var mainTeams: [MainTeam] = []
    private var deleteMode = false
    
    lazy var collectionView: UICollectionView = {
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .vertical
        collectionLayout.minimumInteritemSpacing = 0
        collectionLayout.minimumLineSpacing = 30
        let v = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        v.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: "regionCell")
        v.translatesAutoresizingMaskIntoConstraints = false
        v.dataSource = self
        v.delegate = self
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupNavigationBarButtonItem()
        viewTeams()
    }
}


//MARK: - Setup -
extension TeamsCollectionView {
    func setupUI() {
        view.backgroundColor = .white
        title = "Teams"
        
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func setupNavigationBarButtonItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(setDelete))
    }
}


//MARK: - DataBase Call -
extension TeamsCollectionView {
    @objc func viewTeams() {
        let db = Firestore.firestore()
        db.collection("teams").whereField("pokemones.pokemones0.email", isEqualTo: "edwardpizzurro@gmail.com").getDocuments() { (querySnapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    var teams: [Pokemon] = []
                    for i in 0...5 {
                        if let dictionary = (document.data()["pokemones"] as? Dictionary<String, Any>)?["pokemones\(i)"] as? Dictionary<String, Any> {
                            let pokemon = Pokemon(name: dictionary["name"] as! String, height: Int(dictionary["height"] as! String), weight: Int(dictionary["weight"] as! String), species: nil, specie: dictionary["specie"] as? String, sprites: nil, imageURL: dictionary["imageURL"] as? String)
                            teams.append(pokemon)
                        } else {
                            break
                        }
                    }
                    self.mainTeams.append(MainTeam(id: document.documentID, team: teams))
                    teams = []
                }
                
                self.collectionView.reloadData()
            }
        }
    }
}


//MARK: - Action Methods -
extension TeamsCollectionView {
    @objc func setDelete() {
        deleteMode = true
    }
}


//MARK: - Collection View Methods -
extension TeamsCollectionView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.mainTeams.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "regionCell", for: indexPath) as! MainCollectionViewCell
        cell.configure(title: mainTeams[indexPath.item].id, image: "pokedexIcon")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if deleteMode {
            let alert = Utils().createAlertController(title: "Delete Pokemon", message: "Are you sure you want to delete this team?", actionTitle: "", withAction: false)
            alert.addAction(UIAlertAction(title: "Yes", style: .default) { action -> Void in
                let db = Firestore.firestore()
                db.collection("teams").document(self.mainTeams[indexPath.item].id).delete()
                self.navigationController?.popViewController(animated: true)
            })
            alert.addAction(UIAlertAction(title: "No", style: .cancel))
            self.present(alert, animated: true, completion: nil)
        } else {
            let vc = CategoriasViewController()
            vc.teamPokemones = mainTeams[indexPath.item].team
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
