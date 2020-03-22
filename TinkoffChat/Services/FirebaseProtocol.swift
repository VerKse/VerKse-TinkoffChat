//
//  FirebaseProtocol.swift
//  TinkoffChat
//
//  Created by Vera on 22.03.2020.
//  Copyright © 2020 Vera. All rights reserved.
//
/*
import Foundation
import Firebase

protocol FirebaseService{
    func getData() -> ([ConversationCellModel])
    func saveData()
}

class GeneralFirebaseService: FirebaseService{
    

    
    func saveData() {
        <#code#>
    }
    
    var db:FirebaseService
    var collection: String = ""
    
    init(collection:String) {
        self.collection = collection
    }
    
    func getData() -> ([ConversationCellModel]) {
        let reference = db.collection(collection)
        var data = [ConversationCellModel]()
        var channelList = [Channel]()
        
        FirebaseApp.configure()
        reference.addSnapshotListener { snapshot, error in
                for doc in snapshot!.documents {
                    let date = doc.data()["lastActivity"] as? Timestamp
                    let newChannel = Channel(identifier: doc.documentID,
                                             name: stringFromAny(doc.data()["name"]),
                                             lastMessage: stringFromAny(doc.data()["lastMessage"]),
                                             lastActivity: date?.dateValue())
                    channelList.append(newChannel)
                }
                for channel in channelList{
                    data.append(ConversationCellModel(channel: channel, hasUnreadMessage: false))
                }
        }
        return data
    }
    
    /*func generateHistoryData(dataSet: [ConversationCellModel]) -> ([ConversationCellModel]) {
     var historyData = [ConversationCellModel]()
     for data in dataSet {
     if (data.channel.lastActivity==nil || data.channel.lastActivity!<Date.init(timeIntervalSinceNow: -10*60)) { historyData.append(data) }
     }
     return historyData
     }
     
     func generateOnlineData(dataSet: [ConversationCellModel]) -> ([ConversationCellModel]) {
     var onlineData = [ConversationCellModel]()
     for data in dataSet {
     
     if (data.channel.lastActivity!>Date.init(timeIntervalSinceNow: -10*60)){
     onlineData.append(data)
     }
     onlineData = onlineData.sorted { (ccm1, ccm2) -> Bool in
     if (ccm1.channel.lastActivity! < ccm2.channel.lastActivity!){
     return false
     } else {return true}
     }
     }
     return onlineData
     }*/
}
*/
