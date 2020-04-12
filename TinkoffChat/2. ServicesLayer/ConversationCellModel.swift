//
//  ConversationCellModel.swift
//  TinkoffChat
//
//  Created by Vera on 22.03.2020.
//  Copyright © 2020 Vera. All rights reserved.
//

import Foundation

struct ChannelModel {
    let identifier: String
    let name: String?
    let lastMessage: String?
    let lastActivity: Date?
}

struct ConversationCellModel {
    let channel: ChannelModel
    let hasUnreadMessage : Bool
}

protocol ConversationCellConfiguration {
    associatedtype ConversationCellModel
    
    var channel : ChannelModel {get set}
    var hasUnreadMessage : Bool?{get set}
    
    func configure(with model: ConversationCellModel)
}
