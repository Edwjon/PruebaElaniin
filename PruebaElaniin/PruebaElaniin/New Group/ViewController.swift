//
//  ViewController.swift
//  PruebaElaniin
//
//  Created by Edward Pizzurro on 1/11/23.
//

import UIKit
import GoogleSignIn
import FirebaseAuth
import Firebase
import FacebookLogin

class ViewController: UIViewController {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Inicia sesión!"
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 30)
        return label
    }()
    
    let googleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Google"
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 30)
        return label
    }()
    
    let facebookLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Facebook"
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 30)
        return label
    }()
    
    lazy var googleImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "googleImage")
        iv.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(googleAction))
        iv.addGestureRecognizer(tapGesture)
        return iv
    }()
    
    lazy var facebookImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "facebookImage")
        iv.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(facebookAction))
        iv.addGestureRecognizer(tapGesture)
        return iv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        checkForUserDefaults()
    }
}


//MARK: - Setup -
extension ViewController {
    func setupUI() {
        view.backgroundColor = UIColor(red: 0.459, green: 0.789, blue: 0.916, alpha: 1)
        
        view.addSubview(googleImageView)
        googleImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        googleImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100).isActive = true
        googleImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        googleImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        view.addSubview(titleLabel)
        titleLabel.bottomAnchor.constraint(equalTo: googleImageView.topAnchor, constant: -120).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        view.addSubview(googleLabel)
        googleLabel.topAnchor.constraint(equalTo: googleImageView.bottomAnchor, constant: 20).isActive = true
        googleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        googleLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        googleLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        view.addSubview(facebookImageView)
        facebookImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        facebookImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 150).isActive = true
        facebookImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        facebookImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        view.addSubview(facebookLabel)
        facebookLabel.topAnchor.constraint(equalTo: facebookImageView.bottomAnchor, constant: 20).isActive = true
        facebookLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        facebookLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        facebookLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
}


//MARK: - Class Methods -
extension ViewController {
    func checkForUserDefaults() {
        let defaults = UserDefaults.standard
        if let _ = defaults.value(forKey: "email") as? String, let _ = defaults.value(forKey: "provider") as? String {
            let vc = RegionsViewController()
            navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    func signIn(credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { result, error in
            if let result = result, error == nil {
                let vc = RegionsViewController()
                
                let defaults = UserDefaults.standard
                defaults.set(result.user.email, forKey: "email")
                defaults.synchronize()
                
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                let alert = Utils().createAlertController(title: "Error", message: "Se ha producido un error registrando el usuario", actionTitle: "Ok", withAction: true)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}


//MARK: - Action Methods -
extension ViewController {
    @objc func facebookAction() {
        let loginManager = LoginManager()
        loginManager.logOut()
        
        loginManager.logIn(permissions: [.email], viewController: self) { (result) in
            switch result {
            case .success(granted: _, declined: _, token: let token):
                let credential = FacebookAuthProvider.credential(withAccessToken: token.tokenString)
                
                let defaults = UserDefaults.standard
                defaults.set("facebook", forKey: "provider")
                defaults.synchronize()
                
                self.signIn(credential: credential)
            case .cancelled:
                break
            case .failed(_):
                break
            }
        }
    }
    
    @objc func googleAction() {
        GIDSignIn.sharedInstance.signOut()
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)

        //Sign in flow
        GIDSignIn.sharedInstance.configuration = config

        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] user, error in
            if let error = error {
              print(error)
              return
            }

            let credential = GoogleAuthProvider.credential(withIDToken: (user?.user.idToken?.tokenString)!,
                                                           accessToken: (user?.user.accessToken.tokenString)!)
            
            let defaults = UserDefaults.standard
            defaults.set("google", forKey: "provider")
            defaults.synchronize()
            
            self.signIn(credential: credential)
        }
    }
}
