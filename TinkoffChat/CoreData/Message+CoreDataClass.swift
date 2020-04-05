//
//  Message+CoreDataClass.swift
//  
//
//  Created by Vera on 03.04.2020.
//
//

import Foundation
import CoreData

@objc(Message)
public class Message: NSManagedObject {
    convenience init() {
        self.init(entity: StorageManager.instance.entityForName(entityName: "Message"), insertInto: StorageManager.instance.managedObjectContext)
    }
}
