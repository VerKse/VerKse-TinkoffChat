//
//  CoreDataManager.swift
//  TinkoffChat
//
//  Created by Vera on 28.03.2020.
//  Copyright © 2020 Vera. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager{
    
    //Singleton
    static let instance = CoreDataManager()
    static let managedObject = User()
    
    func activateCoreData(){
        if (CoreDataManager.managedObject.name == nil){
            basicEntity()
        }
    }
    
    // Entity for Name
    func entityForName(entityName: String) -> NSEntityDescription {
        return NSEntityDescription.entity(forEntityName: entityName, in: self.managedObjectContext)!
    }
    
    func fetchRequest(entityName: String, keyForSort: String) -> NSFetchRequest<NSFetchRequestResult>{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let sortDescriptor = NSSortDescriptor(key: keyForSort, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
    
    // var fetchedResultsController = instance.fetchedResultsController(entityName: "User", keyForSort: "name")
    // Fetched Results Controller for Entity Name
    /*func fetchedResultsController(entityName: String, keyForSort: String) -> NSFetchedResultsController<NSFetchRequestResult> {
     let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
     let sortDescriptor = NSSortDescriptor(key: keyForSort, ascending: true)
     fetchRequest.sortDescriptors = [sortDescriptor]
     let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.instance.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
     return fetchedResultsController
     }*/
    
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

extension CoreDataManager: StorageProtocol{
    func activate() {
        if (CoreDataManager.managedObject.name == nil){
            basicEntity()
        }
    }
    
    func basicEntity() {
        CoreDataManager.managedObject.name = "Иван Иванов"
        CoreDataManager.managedObject.about = "\u{1F496} программировать под iOS \n😍 убирать варнинги \n😍 верстать в storyboard'ах\n\u{1F496} убирать варнинги \n\u{1F496} ещё раз убирать варнинги"
        CoreDataManager.managedObject.avatar = "userMainColor.png"
        CoreDataManager.instance.saveContext()
    }
    
    func load(completion: @escaping (User?) -> Void) {
        let fetchRequest = CoreDataManager.instance.fetchRequest(entityName: "User", keyForSort: "name")
        let userList = try? CoreDataManager.instance.managedObjectContext.fetch(fetchRequest)
        completion(userList?.first as? User)
    }
    
    func save(profile: User, completion: @escaping (Bool) -> Void) {
        
        CoreDataManager.managedObject.name = profile.name
        CoreDataManager.managedObject.about = profile.about
        CoreDataManager.managedObject.avatar = profile.avatar
        
        CoreDataManager.instance.saveContext()
        completion(true)
    }
}
