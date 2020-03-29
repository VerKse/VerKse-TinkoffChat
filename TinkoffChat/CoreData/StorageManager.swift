//
//  CoreDataContainerManager.swift
//  TinkoffChat
//
//  Created by Vera on 29.03.2020.
//  Copyright © 2020 Vera. All rights reserved.
//

import Foundation
import CoreData

class StorageManager {
    
    private(set) static var container = activateContainer()
    var user : User?
    
    private static func activateContainer() -> NSPersistentContainer {
        let container = NSPersistentContainer(name: "TinkoffChatt")
        container.loadPersistentStores(completionHandler: { _, _ in }) /*{ (persistentStoreDescription, error) in
        if let error = error {
            assertionFailure(error.localizedDescription)
        }*/
        print("Container is ready to use")
    
        return container
    }
}

extension StorageManager: StorageProtocol{
    func activate(){
        StorageManager.container.loadPersistentStores { (_, error) in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
        }
        
        StorageManager.container.performBackgroundTask{ (context) in
            let fetchRequest = NSFetchRequest<User>(entityName: "User")
            let allUsers = try? context.fetch(fetchRequest)
            if (allUsers?.isEmpty ?? true) {
                self.basicEntity()
            }
        }
    }
    
    func load(completion: @escaping (User?) -> Void) {
        
        StorageManager.container.performBackgroundTask { (context) in
            let fetchRequest = NSFetchRequest<User>(entityName: "User")
            let allUsers = try? context.fetch(fetchRequest)
            
            self.user = allUsers?.first
            completion(self.user)
            //completion(UserInfo(name: allUsers?.first?.name ?? "Default Nmae", about: allUsers?.first?.about, image: allUsers?.first?.avatar))
        }
        
    }
    
    func save(profile: User, completion: @escaping (Bool) -> Void) {
        StorageManager.container.performBackgroundTask { (context) in
            self.user?.name = profile.name
            self.user?.about = profile.about
            self.user?.avatar = profile.avatar
            if (context.hasChanges) {
                try? context.save()
                
            }
        }
    }
    
    func basicEntity() {
        StorageManager.container.performBackgroundTask { (context) in
            let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as? User
            user?.name = "Ivan Ivanov"
            try? context.save()
        }
    }
    
}
