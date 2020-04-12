//
//  ChannelListFRCDelegate.swift
//  TinkoffChat
//
//  Created by Vera on 12.04.2020.
//  Copyright © 2020 Vera. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class FRCDelegate: NSObject, NSFetchResultsControllerDelegate {

    private let tableView: UITableView
 
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        let section = IndexSet(integer: sectionIndex)
        
        switch type {
        case .delete:
            tableView.deleteSections(section, with: .automatic)
        case .insert:
            tableView.insertSections(section, with: .automatic)
        case .move:
            break
        case .update:
            break
        @unknown default:
            break
        }
    }
    
    private func controller(controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [(indexPath as IndexPath)], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                let channel = channelFetchedResultsController.object(at: indexPath as IndexPath) as! Channel
                let cell = tableView.cellForRow(at: indexPath as IndexPath) as! ConversationCell
                cell.nameLable.text = channel.name
            }
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [(indexPath as IndexPath)], with: .automatic)
            }
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [(newIndexPath as IndexPath)], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [(indexPath as IndexPath)], with: .automatic)
            }
        @unknown default: break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
