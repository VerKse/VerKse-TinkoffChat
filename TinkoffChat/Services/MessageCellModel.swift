//
//  MessageCellModel.swift
//  TinkoffChat
//
//  Created by Vera on 22.03.2020.
//  Copyright © 2020 Vera. All rights reserved.
//
import Foundation

struct MessageCellModel  {
    let content: String
    let created: Date
    let senderId: String
    let senderName: String
}

protocol MessageCellConfiguration: class {
    
    associatedtype MessageCellModel
    
    var content: String {get set}
    var created: Date {get set}
    var senderId: String {get set}
    var senderName: String {get set}
    
    func configure(with model: ConversationCellModel)
}


extension MessageCellModel {
    var toDict: [String: Any] {
        return ["content": content,
                "created": created,
                "senderID": senderId,
                "senderName": senderName]
    }
}
