//
//  ConversationCell2.swift
//  TinkoffChat
//
//  Created by Vera on 05.03.2020.
//  Copyright © 2020 Vera. All rights reserved.
//

import UIKit

class ConversationCell2: UITableViewCell {
    
    var inputMessText = UITextView()
    var outputMessText = UITextView()
    var cellLable = ConversationCell2()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellLable.addSubview(inputMessText)
        cellLable.addSubview(outputMessText)

        inputMessText.backgroundColor = .black
        inputMessText.translatesAutoresizingMaskIntoConstraints = false
        cellLable.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            inputMessText.topAnchor.constraint(equalTo: cellLable.topAnchor),
            inputMessText.leadingAnchor.constraint(equalTo: cellLable.leadingAnchor),
            inputMessText.widthAnchor.constraint(equalToConstant: 50),
            inputMessText.widthAnchor.constraint(equalToConstant: 50),
            inputMessText.bottomAnchor.constraint(equalTo: cellLable.bottomAnchor),
            inputMessText.trailingAnchor.constraint(equalTo: cellLable.trailingAnchor),
            inputMessText.widthAnchor.constraint(equalToConstant: 50),
            inputMessText.widthAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
