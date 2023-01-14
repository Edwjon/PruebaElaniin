//
//  HomeViewController.swift
//  PruebaElaniin
//
//  Created by Edward Pizzurro on 1/11/23.
//

import UIKit
import GoogleSignIn
import FirebaseAuth
import Firebase
import FirebaseFirestore
import FacebookLogin

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @objc func qlq() {
        print("hello")
        
        let db = Firestore.firestore()
        
        //Add
        db.collection("users").document("edwardpizzurro@gmail.com").setData([
            "name":"epf",
            "color":"orange"
        ])

        //Read
        db.collection("users").document("edwardpizzurro@gmail.com").getDocument {
            (documentSnapshot, error) in
            if let document = documentSnapshot, error == nil {
                if let name = document.get("name") as? String {
                    print(name)
                }
                if let color = document.get("color") as? String {
                    print(color)
                }
            }
        }
        
        //Delete
        db.collection("users").document("edwardpizzurro@gmail.com").delete()
    }

}
