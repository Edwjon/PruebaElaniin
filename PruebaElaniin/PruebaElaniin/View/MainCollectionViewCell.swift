//
//  MainCollectionViewCell.swift
//  PruebaElaniin
//
//  Created by Edward Pizzurro on 1/16/23.
//

import Foundation
import UIKit

class MainCollectionViewCell: UICollectionViewCell {
    
    let mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 25)
        return label
    }()
    
    let regionIcon: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //Add regionIcon to cell
        addSubview(regionIcon)
        regionIcon.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
        regionIcon.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        regionIcon.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        regionIcon.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        //Add mainLabel to cell
        addSubview(mainLabel)
        mainLabel.leftAnchor.constraint(equalTo: regionIcon.rightAnchor, constant: 15).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        mainLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        mainLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    func configure(title: String, image: String) {
        self.mainLabel.text = title
        self.regionIcon.image = UIImage(named: image)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

