//
//  ConversationCell2.swift
//  TinkoffChat
//
//  Created by Vera on 08.03.2020.
//  Copyright © 2020 Vera. All rights reserved.
//

import Foundation
import UIKit


class ConversationCell: UITableViewCell {
    
    var avatarImg: UIImageView = {
        var imgview = UIImageView()
        imgview.translatesAutoresizingMaskIntoConstraints = false
        imgview.backgroundColor = .blueGrey500
        return imgview
    }()

    var nameLable: UILabel = {
        var textlable = UILabel()
        textlable.translatesAutoresizingMaskIntoConstraints = false
        textlable.font = .boldSystemFont(ofSize: 16)
        textlable.textColor = .blueGrey900
        return textlable
    }()
    var messageLable: UILabel = {
        var textlable = UILabel()
        textlable.font = .systemFont(ofSize: 16)
        textlable.translatesAutoresizingMaskIntoConstraints = false
        textlable.textColor = .blueGrey500
        return textlable
    }()
    var dateLable: UILabel = {
        var textlable = UILabel()
        textlable.translatesAutoresizingMaskIntoConstraints = false
        textlable.font = .systemFont(ofSize: 12)
        textlable.textAlignment = .right
        textlable.textColor = .blueGrey500
        return textlable
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(nameLable)
        self.addSubview(messageLable)
        self.addSubview(dateLable)
        self.addSubview(avatarImg)
        
        NSLayoutConstraint.activate([
            avatarImg.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            avatarImg.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15),
            avatarImg.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),
            avatarImg.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.15),
            avatarImg.widthAnchor.constraint(equalTo: avatarImg.heightAnchor),
            
            nameLable.topAnchor.constraint(equalTo: avatarImg.topAnchor),
            nameLable.leftAnchor.constraint(equalTo: avatarImg.rightAnchor, constant: 10),
            nameLable.rightAnchor.constraint(equalTo: dateLable.leftAnchor, constant: -10),
            
            messageLable.topAnchor.constraint(equalTo: nameLable.bottomAnchor, constant: 10),
            messageLable.leftAnchor.constraint(equalTo: avatarImg.rightAnchor, constant: 10),
            messageLable.rightAnchor.constraint(equalTo: dateLable.leftAnchor, constant: -10),
            
            dateLable.topAnchor.constraint(equalTo: nameLable.topAnchor),
            dateLable.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.15),
            dateLable.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10)
        ])
        avatarImg.layer.cornerRadius = 30//avatarImg.frame.height/2
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
