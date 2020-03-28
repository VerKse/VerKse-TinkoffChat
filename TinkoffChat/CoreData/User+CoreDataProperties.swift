//
//  User+CoreDataProperties.swift
//  TinkoffChat
//
//  Created by Vera on 28.03.2020.
//  Copyright © 2020 Vera. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var name: String?
    @NSManaged public var about: String?
    @NSManaged public var avatar: URL?

}
