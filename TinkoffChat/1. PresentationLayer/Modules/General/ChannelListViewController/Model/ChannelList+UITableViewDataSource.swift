//
//  ChannelList+UITableViewDataSource.swift
//  TinkoffChat
//
//  Created by Vera on 05.04.2020.
//  Copyright © 2020 Vera. All rights reserved.
//

import Foundation
import UIKit
import CoreData


@available(iOS 13.0, *)
extension ChannelListViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channelFetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = String(describing: ConversationCell.self)
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ConversationCell else {
            return UITableViewCell()
        }
        
        var channel = Channel(context: StorageManager.instance.persistentContainer.viewContext)
        
        switch indexPath.section {
        case 0:
            cell.backgroundColor = .yellowLight
        case 1:
            cell.backgroundColor = .white
        default:
            break;
        }
        
        channel = channelFetchedResultsController.object(at: indexPath) as! Channel
        cell.nameLable.text = channel.name
        cell.identifierLable.text = channel.identifier
        
        //date
        let formatter = DateFormatter()
        if (channel.lastActivity == nil ) {
            cell.dateLable.text = "date"
        } else {
            if(Calendar.current.isDateInToday(channel.lastActivity!)) {
                formatter.dateFormat = "HH:mm"
            } else {
                formatter.dateFormat = "dd MMM"
            }
            cell.dateLable.text = formatter.string(from: channel.lastActivity!)
        }
        
        //message
        if (channel.lastMessage != nil) {
            cell.messageLable.font = .systemFont(ofSize: 16)
            cell.messageLable.text = channel.lastMessage
        } else {
            cell.messageLable.font = .systemFont(ofSize: 16)
            cell.messageLable.text = "No messages yet"
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = channelFetchedResultsController.sections?.count {
            return sections
        } else {return 0}
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) as? ConversationCell else {return}
        
        let conversationViewController = ConversationViewController.init(channelIdentifier: cell.identifierLable.text,
                                                                         channelName: cell.nameLable.text)
        navigationController?.pushViewController(conversationViewController, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete {
            let managedObject = channelFetchedResultsController.object(at: indexPath as IndexPath) as! Channel
            deleteChannel(withIdentifier: managedObject.identifier!)
            StorageManager.instance.managedObjectContext.delete(managedObject)
            StorageManager.instance.saveContext()
        }
    }
    
    func deleteChannel(withIdentifier: String){
        self.reference.document(withIdentifier).delete() { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
}
