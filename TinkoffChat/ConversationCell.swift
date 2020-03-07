//
//  ConversationCell.swift
//  TinkoffChat
//
//  Created by Vera on 01.03.2020.
//  Copyright © 2020 Vera. All rights reserved.
//

import UIKit

class ConversationCell: UITableViewCell {

    @IBOutlet weak var cellLable: ConversationCell!
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var messageLable: UILabel!
    @IBOutlet weak var dateLable: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //let testCell = ConversationCell()
        
        /*
        self.cellLable.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.cellLable.translatesAutoresizingMaskIntoConstraints = false
        self.nameLable.translatesAutoresizingMaskIntoConstraints = false
        self.messageLable.translatesAutoresizingMaskIntoConstraints = false
        self.dateLable.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.nameLable.leadingAnchor.constraint(equalTo: cellLable.leadingAnchor, constant: 10),
            self.dateLable.trailingAnchor.constraint(equalTo: messageLable.leadingAnchor, constant: 10),
            self.messageLable.leadingAnchor.constraint(equalTo: nameLable.trailingAnchor, constant: 10)
        ])*/
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        //cellLable.backgroundColor = .white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

