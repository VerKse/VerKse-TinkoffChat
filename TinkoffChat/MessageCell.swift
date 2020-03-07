//
//  MessageCell.swift
//  TinkoffChat
//
//  Created by Vera on 01.03.2020.
//  Copyright © 2020 Vera. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    @IBOutlet weak var cellLable: MessageCell!
    @IBOutlet weak var inputMessText: UITextView!
    @IBOutlet weak var outputMessText: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
