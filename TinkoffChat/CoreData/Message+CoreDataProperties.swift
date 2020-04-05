//
//  Message+CoreDataProperties.swift
//  
//
//  Created by Vera on 03.04.2020.
//
//

import Foundation
import CoreData


extension Message {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message")
    }

    @NSManaged public var content: String?
    @NSManaged public var created: Date
    @NSManaged public var senderName: String?
    @NSManaged public var channel: Channel?
    @NSManaged public var sender: User?

}
