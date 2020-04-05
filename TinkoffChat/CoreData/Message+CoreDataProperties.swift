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

    @NSManaged public var text: String?
    @NSManaged public var time: Date?
    @NSManaged public var channelID: Channel?

}
