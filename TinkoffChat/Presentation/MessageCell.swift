//
//  MessageCellPro.swift
//  TinkoffChat
//
//  Created by Vera on 07.03.2020.
//  Copyright © 2020 Vera. All rights reserved.
//

import Foundation
import UIKit

class MessageCell: UITableViewCell {

    var inputMessText : UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.layer.cornerRadius = 20
        textView.font = .systemFont(ofSize: 14)
        textView.textContainerInset = UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 15);
        return textView
    }()
    
    var senderNameLable : UILabel = {
        var lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.text = ""
        lable.font = UIFont.boldSystemFont(ofSize: 16)
        lable.textColor = .mainColor
        return lable
    }()
    
    var timeLable : UILabel = {
        var lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.text = ""
        lable.font = .systemFont(ofSize: 10)
        lable.textColor = .mainColor
        return lable
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(timeLable)
        self.addSubview(inputMessText)
        self.addSubview(senderNameLable)
        
        NSLayoutConstraint.activate([
            senderNameLable.leftAnchor.constraint(equalTo: inputMessText.leftAnchor, constant: 10),
            senderNameLable.bottomAnchor.constraint(equalTo: inputMessText.topAnchor, constant: -5),
            senderNameLable.widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor, multiplier: 0.75)
        ])
        
        NSLayoutConstraint.activate([
            inputMessText.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            inputMessText.topAnchor.constraint(equalTo: self.topAnchor, constant: 30),
            inputMessText.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30),
            inputMessText.widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor, multiplier: 0.75),
            inputMessText.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            timeLable.leftAnchor.constraint(equalTo: inputMessText.leftAnchor, constant: 10),
            timeLable.topAnchor.constraint(equalTo: inputMessText.bottomAnchor, constant: 5),
            timeLable.widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor, multiplier: 0.75)
        ])
        
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
