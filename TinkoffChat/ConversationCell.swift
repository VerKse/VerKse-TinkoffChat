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
    
    var nameLable: UILabel = {
        var textlable = UILabel()
        textlable.translatesAutoresizingMaskIntoConstraints = false
        return textlable
    }()
    var messageLable: UILabel = {
        var textlable = UILabel()
        textlable.translatesAutoresizingMaskIntoConstraints = false
        return textlable
    }()
    var dateLable: UILabel = {
        var textlable = UILabel()
        textlable.translatesAutoresizingMaskIntoConstraints = false
        //textlable.textAlignment = NSTextAlignment.left
        return textlable
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(nameLable)
        self.addSubview(messageLable)
        self.addSubview(dateLable)
        
        NSLayoutConstraint.activate([
            nameLable.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            nameLable.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            nameLable.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.2),
            
            messageLable.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            messageLable.leftAnchor.constraint(equalTo: nameLable.rightAnchor, constant: 10),
            messageLable.rightAnchor.constraint(equalTo: dateLable.leftAnchor, constant: -10),
            
            dateLable.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            dateLable.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.2),
            dateLable.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
