//
//  Channel+CoreDataClass.swift
//  
//
//  Created by Vera on 05.04.2020.
//
//

import Foundation
import CoreData

@objc(Channel)
public class Channel: NSManagedObject {
    convenience init() {
        self.init(entity: StorageManager.instance.entityForName(entityName: "Channel"), insertInto: StorageManager.instance.managedObjectContext)
    }    
}
