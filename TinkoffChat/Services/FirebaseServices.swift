//
//  FirebaseServices.swift
//  TinkoffChat
//
//  Created by Vera on 05.04.2020.
//  Copyright © 2020 Vera. All rights reserved.
//

import Foundation
import Firebase
import CoreData

class ChannelServices{
    
    static let instance = ChannelServices()
    var db = Firestore.firestore()
    var reference: CollectionReference
    
    init(){
        self.reference = db.collection("channels")
    }
    
    func listener(completion: @escaping (Bool) -> Void){
        var channelList = Array<Channel>()
        reference.addSnapshotListener { [weak self]snapshot, error in
            
            for doc in snapshot!.documents {
                let date = doc.data()["lastActivity"] as? Timestamp
                let channelManagedObject = Channel()
                channelManagedObject.name = stringFromAny(doc.data()["name"])
                channelManagedObject.identifier = doc.documentID
                channelManagedObject.lastMessage = stringFromAny(doc.data()["lastMessage"])
                channelManagedObject.lastActivity = date?.dateValue()
                guard (channelManagedObject.lastActivity != nil) else {
                    StorageManager.instance.saveContext()
                    return
                }
                if (channelManagedObject.lastActivity! < Date.init(timeIntervalSinceNow: -10*60)){
                    channelManagedObject.isActive = true
                }else {channelManagedObject.isActive = false}
                channelList.append(channelManagedObject)
            }
            
            let fetchRequest = StorageManager.instance.fetchRequest(entityName: "Channel", sortDescriptor: [NSSortDescriptor(key: "identifier", ascending: true)], predicate: nil)
            
            if (channelList.count != 0) {
                let fetchedChannels = try? StorageManager.instance.managedObjectContext.fetch(fetchRequest)
                guard (fetchedChannels != nil) else {
                    completion(false)
                    return
                }
                for object in fetchedChannels!{
                    for channel in channelList{
                        let coreChannel = object as! Channel
                        if (coreChannel.identifier == channel.identifier){
                            channelList.removeAll(where: {$0 == channel} )
                        } else {
                            coreChannel.name = channel.name
                            coreChannel.lastMessage = channel.lastMessage
                            coreChannel.lastActivity = channel.lastActivity
                            coreChannel.isActive = channel.isActive
                        }
                    }
                }
                StorageManager.instance.saveContext()
            }
        }
        completion(true)
    }
}

class MessageServices{
    
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
