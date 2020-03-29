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
    
    private static func activateContainer() -> NSPersistentContainer {
        let container = NSPersistentContainer(name: "TinkoffChatt")
        container.loadPersistentStores(completionHandler: { _, _ in }) /*{ (persistentStoreDescription, error) in
        if let error = error {
            assertionFailure(error.localizedDescription)
        }*/
        print("Container is ready to use")
        
        
        //Создание стартовой сущности
        container.performBackgroundTask { (context) in
            let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as? User
            user?.name = "Ivan Ivanov"
            try? context.save()
        }
        
        return container
    }
    
    func fetchedResultsController(entityName: String, keyForSort: String) -> NSFetchedResultsController<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let sortDescriptor = NSSortDescriptor(key: keyForSort, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.instance.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }

}

extension StorageManager: StorageProtocol{
    
    func load(completion: @escaping (UserInfo?) -> Void) {
        StorageManager.container.loadPersistentStores { (_, error) in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
        }
        
        StorageManager.container.performBackgroundTask { (context) in
            let fetchRequest = NSFetchRequest<User>(entityName: "User")
            let allUsers = try? context.fetch(fetchRequest)

            completion(UserInfo(name: allUsers?.first?.name ?? "Default Nmae", about: allUsers?.first?.about, image: allUsers?.first?.avatar))
        }
        
    }
    
    func save(profile: UserInfo, completion: @escaping (Bool) -> Void) {
        StorageManager.container.performBackgroundTask { (context) in
            let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as? User
            user?.name = profile.name
            user?.about = profile.about
            user?.avatar = profile.image
            try? context.save()
        }
    }
    
}
