//
//  ConversationCellModel.swift
//  TinkoffChat
//
//  Created by Vera on 22.03.2020.
//  Copyright © 2020 Vera. All rights reserved.
//

import Foundation

struct ConversationCellModel {
    let channel: Channel
    let hasUnreadMessage : Bool
}

protocol ConversationCellConfiguration {
    associatedtype ConversationCellModel
    
    var channel : Channel {get set}
    var hasUnreadMessage : Bool?{get set}
    
    func configure(with model: ConversationCellModel)
}