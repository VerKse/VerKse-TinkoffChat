//
//  ChannelListServices.swift
//  TinkoffChat
//
//  Created by Vera on 05.04.2020.
//  Copyright © 2020 Vera. All rights reserved.
//

import Foundation
import Firebase
import CoreData

class ChannelListServices{
    
    var db = Firestore.firestore()
    var reference: CollectionReference
    
    init(){
        self.reference = db.collection("channels")
    }
    
    func listener(completion: @escaping (Bool) -> Void){
        reference.addSnapshotListener { [weak self] snapshot, error in
            var channelList = Array<Channel>()
            for doc in snapshot!.documents {
                do{
                    let date = doc.data()["lastActivity"] as? Timestamp
                    
                    let channelManagedObject = Channel(context: StorageManager.instance.persistentContainer.viewContext)
                    
                    channelManagedObject.name = stringFromAny(doc.data()["name"])
                    channelManagedObject.identifier = doc.documentID
                    channelManagedObject.lastMessage = stringFromAny(doc.data()["lastMessage"])
                    channelManagedObject.lastActivity = date?.dateValue()
                    
                    guard (channelManagedObject.lastActivity != nil) else {
                        channelManagedObject.isActive = false
                        return
                    }
                    
                    channelManagedObject.isActive = channelManagedObject.lastActivity! < Date.init(timeIntervalSinceNow: -10*60)
                    
                    try StorageManager.instance.persistentContainer.viewContext.save()
                } catch {
                    print(error.localizedDescription)
                }
                
                /*let fetchRequest = StorageManager.instance.fetchRequest(entityName: "Channel", sortDescriptor: [NSSortDescriptor(key: "identifier", ascending: true)], predicate: nil)
                
                if (channelList.count != 0) {
                    let fetchedChannels = try? StorageManager.instance.managedObjectContext.fetch(fetchRequest)
                    guard (fetchedChannels != nil) else {
                        return
                    }
                    for object in fetchedChannels!{
                        for channel in channelList{
                            let coreChannel = object as! Channel
                            if (coreChannel.identifier == channel.identifier){
                                coreChannel.name = channel.name
                                coreChannel.lastMessage = channel.lastMessage
                                coreChannel.lastActivity = channel.lastActivity
                                coreChannel.isActive = channel.isActive
                                channelList.removeAll(where: {$0 == channel} )
                            }
                        }
                    }*/
                    StorageManager.instance.saveContext()
                }
            }
            completion(true)
        }
}

