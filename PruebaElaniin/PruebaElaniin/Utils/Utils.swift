//
//  Utils.swift
//  PruebaElaniin
//
//  Created by Edward Pizzurro on 1/17/23.
//

import Foundation
import UIKit

class Utils: NSObject {
    func createAlertController(title: String, message: String, actionTitle: String, withAction: Bool) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if withAction {
            alertController.addAction(UIAlertAction(title: actionTitle, style: .default))
        }
        return alertController
    }
    
    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
}
