//
//  GalleryCollectionCell.swift
//  TinkoffChat
//
//  Created by Vera on 19.04.2020.
//  Copyright © 2020 Vera. All rights reserved.
//

import UIKit

class GalleryCollectionCell: UICollectionViewCell {
    var imageView: UIImageView = {
        var iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .none
        iv.image = UIImage.init(named: "placeHolder.png")
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 5
        self.backgroundColor = .mainLightColor
        self.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.rightAnchor.constraint(equalTo: self.rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            imageView.leftAnchor.constraint(equalTo: self.leftAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
