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
        textView.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 10);
        return textView
    }()
    
    var outputMessText : UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.layer.cornerRadius = 20
        textView.font = .systemFont(ofSize: 14)
        textView.textContainerInset = UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 15);
        return textView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(inputMessText)
        self.addSubview(outputMessText)
        
        NSLayoutConstraint.activate([
            inputMessText.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            inputMessText.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            inputMessText.widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor, multiplier: 0.75),
            inputMessText.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])

        NSLayoutConstraint.activate([
            outputMessText.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
            outputMessText.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            outputMessText.widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor, multiplier: 0.75),
            outputMessText.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
