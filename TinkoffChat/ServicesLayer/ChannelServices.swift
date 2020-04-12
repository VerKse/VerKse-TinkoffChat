//
//  FirebaseServices.swift
//  TinkoffChat
//
//  Created by Vera on 05.04.2020.
//  Copyright © 2020 Vera. All rights reserved.
//

import Foundation
import CoreData
import Firebase

class ChannelServices{
    
    var db = Firestore.firestore()
    var reference: CollectionReference
    
    init(channelIdentifier: String?){
        guard (channelIdentifier != nil) else { fatalError() }
        self.reference = db.collection("channels").document(channelIdentifier!).collection("messages")
    }
    
    func listener(completion: @escaping (Bool) -> Void){
        var messageList = Array<Message>()
        reference.addSnapshotListener { [weak self]snapshot, error in
            
            for doc in snapshot!.documents {
                let date = doc.data()["created"] as! Timestamp
                let message = Message()
                message.content = stringFromAny(doc.data()["content"])
                message.created = date.dateValue()
                let sender = User()
                sender.identifier = stringFromAny(doc.data()["senderID"])
                sender.name = stringFromAny(doc.data()["senderName"])
                message.sender = sender
                let channel = Channel()
                channel.identifier = doc.documentID
                message.channel = channel
                messageList.append(message)
            }
        }
        
        let fetchRequest = StorageManager.instance.fetchRequest(entityName: "Message", sortDescriptor: [NSSortDescriptor(key: "created", ascending: true)], predicate: nil)
        
        if (messageList.count != 0) {
            let fetchedMessages = try? StorageManager.instance.managedObjectContext.fetch(fetchRequest)
            guard (fetchedMessages != nil) else {
                completion(false)
                return
            }
            for object in fetchedMessages!{
                for message in messageList{
                    let coreMessage = object as! Message
                    if (coreMessage == message){
                        messageList.removeAll(where: {$0 == message} )
                    }
                }
            }
            StorageManager.instance.saveContext()
        }
        completion(true)
    }
}
