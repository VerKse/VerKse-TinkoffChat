//
//  MessagesProtocol.swift
//  TinkoffChat
//
//  Created by Vera on 22.03.2020.
//  Copyright © 2020 Vera. All rights reserved.
//

import Foundation
import Firebase

protocol MessagesService{
    var channel: Channel { get set }
    var db: Firestore { get set }
    
    func setData(tableView:UITableView)
    func saveData(message: MessageCellModel)
}

class GeneralMessagesService: MessagesService{
    func saveData(message: MessageCellModel) {
        reference.addDocument(data: message.toDict)
    }
    
    func setData(tableView: UITableView) {
        var messageList = [MessageCellModel]()
        reference.addSnapshotListener { snapshot, error in
            
            for doc in snapshot!.documents {
                let date = doc.data()["created"] as! Timestamp
                
                let newMess = MessageCellModel(content: doc.data()["content"] as! String,
                                               created: date.dateValue(),
                                               senderId: stringFromAny(doc.data()["senderID"]),
                                                senderName: stringFromAny(doc.data()["senderName"]))
                messageList.append(newMess)
            }
            
            messageList = (messageList.sorted(by: { (mcm1, mcm2) -> Bool in
                if (mcm1.created < mcm2.created){
                    return true
                } else {return false}
            }))
            tableView.reloadData()
            if (messageList.count != 0) {
                tableView.scrollToRow(at: IndexPath(item:(messageList.count) - 1, section: 0), at: .bottom, animated: false)
            }
        }
        
    }
    

    
    var channel:Channel
    var db:Firestore = Firestore.firestore()
    var reference : CollectionReference
    
    init(channel:Channel) {
        self.channel = channel
        
        reference = db.collection("channels").document(channel.identifier).collection("messages")
    }
    
}
