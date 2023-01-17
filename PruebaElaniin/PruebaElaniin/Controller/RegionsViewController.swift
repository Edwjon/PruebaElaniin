//
//  RegionsViewController.swift
//  PruebaElaniin
//
//  Created by Edward Pizzurro on 1/12/23.
//

import UIKit
import GoogleSignIn
import FirebaseAuth
import Firebase
import FirebaseFirestore
import FacebookLogin

class RegionsViewController: UIViewController {
    
    private let networkManager = NetworkManager()
    var regions: [Region] = []
    
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
        
        setupNavigationBarButtons()
        setupUI()
        apiCall()
    }
}


//MARK: - Setup Methods -
extension RegionsViewController {
    func setupUI() {
        view.backgroundColor = .white
        title = "Regiones"
        navigationItem.setHidesBackButton(true, animated: false)
        
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func setupNavigationBarButtons() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Teams", style: .plain, target: self, action: #selector(viewTeams))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(signOut))
    }
}

//MARK: - API Calls -
extension RegionsViewController {
    func apiCall() {
        for i in 1...9 {
            networkManager.get(id: i, name: nil, endPoint: Endpoints.region.rawValue) { (result: Result<Region,Error>) in
                switch result {
                case .success(let region):
                    /// if the data is retrieved
                    DispatchQueue.main.async {
                        self.regions.append(region)
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


//MARK: - Navigation Methods -
extension RegionsViewController {
    @objc func viewTeams() {
        let vc = TeamsCollectionView()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func signOut() {
        do {
            try Auth.auth().signOut()
            
            if let provider = UserDefaults.standard.value(forKey: "provider"), provider as? String == "google" {
                GIDSignIn.sharedInstance.signOut()
            } else {
                LoginManager().logOut()
            }
            
            let defaults = UserDefaults.standard
            defaults.removeObject(forKey: "email")
            defaults.removeObject(forKey: "provider")
            defaults.synchronize()
            
            navigationController?.popViewController(animated: true)
        } catch {
            print(error)
        }
    }
}


//MARK: - Collection View Methods -
extension RegionsViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.regions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "regionCell", for: indexPath) as! MainCollectionViewCell
        cell.configure(title: regions[indexPath.item].name, image: "regionIcon")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = PokedexViewController()
        vc.region = regions[indexPath.item]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
