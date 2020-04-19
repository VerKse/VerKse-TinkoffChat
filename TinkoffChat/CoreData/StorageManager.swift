//
//  StorageManager.swift
//  TinkoffChat
//
//  Created by Vera on 12.04.2020.
//  Copyright © 2020 Vera. All rights reserved.
//

import Foundation
import CoreData
import Firebase

class StorageManager{
    
    //Singleton
    static let instance = StorageManager()
    static let managedObject = User()
    
    func activateCoreData(){
        if (StorageManager.managedObject.name == nil){
            basicEntity()
        }
    }
    
    // Entity for Name
    func entityForName(entityName: String) -> NSEntityDescription {
        return NSEntityDescription.entity(forEntityName: entityName, in: self.managedObjectContext)!
    }
    
    func fetchRequest(entityName: String, sortDescriptor: Array <NSSortDescriptor>, predicate: NSPredicate?) -> NSFetchRequest<NSFetchRequestResult>{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.sortDescriptors = sortDescriptor
        fetchRequest.fetchBatchSize = 10
        return fetchRequest
    }
    
    func fetchedResultsController(entityName: String, sortDescriptor: Array <NSSortDescriptor>, sectionNameKeyPath: String?, predicate: NSPredicate?, cacheName: String?) -> NSFetchedResultsController<NSFetchRequestResult> {
        let fr = fetchRequest(entityName: entityName, sortDescriptor: sortDescriptor, predicate: predicate)
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: StorageManager.instance.managedObjectContext, sectionNameKeyPath: sectionNameKeyPath, cacheName: cacheName)
        return fetchedResultsController
    }
    
    // MARK: - Core Data stack
    lazy var applicationDocumentsDirectory: NSURL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1] as NSURL
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: "TinkoffChat", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                               configurationName: nil,
                                               at: url,
                                               options: nil)
        } catch {
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    //MARK: Core Data saving support
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "TinkoffChat")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

//MARK: ProfileManager
extension StorageManager: StorageProtocol{
    func activate(completion: @escaping (Bool) -> Void) {
        if (StorageManager.managedObject.name == nil){
            basicEntity()
        }
        completion(true)
    }
    
    func basicEntity() {
        StorageManager.managedObject.name = "Иван Иванов"
        StorageManager.managedObject.about = "\u{1F496} программировать под iOS 😍 убирать варнинги 😍 верстать в storyboard'ах \u{1F496} убирать варнинги \u{1F496} ещё раз убирать варнинги"
        StorageManager.managedObject.avatar = "userMainColor.png"
        StorageManager.instance.saveContext()
    }
    
    func load(completion: @escaping (User?) -> Void) {
        let fetchRequest = StorageManager.instance.fetchRequest(entityName: "User", sortDescriptor: [NSSortDescriptor(key: "name", ascending: true)], predicate: nil)
        let userList = try? StorageManager.instance.managedObjectContext.fetch(fetchRequest)
        completion(userList?.first as? User)
    }
    
    func save(profile: User, completion: @escaping (Bool) -> Void) {
        
        StorageManager.managedObject.name = profile.name
        StorageManager.managedObject.about = profile.about
        StorageManager.managedObject.avatar = profile.avatar
        
        StorageManager.instance.saveContext()
        completion(true)
    }
     
}

//MARK: ChannelManager
extension StorageManager{
    
}