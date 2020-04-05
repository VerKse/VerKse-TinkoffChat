//
//  User+CoreDataClass.swift
//  TinkoffChat
//
//  Created by Vera on 28.03.2020.
//  Copyright © 2020 Vera. All rights reserved.
//
//

import Foundation
import CoreData

@objc(User)
public class User: NSManagedObject {
    convenience init() {
        self.init(entity: StorageManager.instance.entityForName(entityName: "User"), insertInto: StorageManager.instance.managedObjectContext)
    }
}
