//
//  CoreDataStackManager.swift
//  Nail Technican Helper
//
//  Created by Hieu Vo on 4/4/16.
//  Copyright © 2016 Hieu Vo. All rights reserved.
//

import CoreData

private let SQLite_File_Name = "NailTechnicanHelper.sqlite"

class CoreDataStackManager {
    class func sharedInstance() -> CoreDataStackManager {
        struct Static {
            static let instance = CoreDataStackManager()
        }
        return Static.instance
    }
    let options = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
    
    func mirgationData(_ option : NSDictionary?){
        
    }
    
    lazy var applicationDocumentDirectory : URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count - 1]
    }()
    
    lazy var managerObjectModel : NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: "Model", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoodinator : NSPersistentStoreCoordinator? = {
        let coodinator : NSPersistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managerObjectModel)
        let url =  self.applicationDocumentDirectory.appendingPathComponent(SQLite_File_Name)
        do {
            try coodinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: self.options)
        }catch {
            abort()
        }
        return coodinator
    }()
    
    lazy var managerObjectContext : NSManagedObjectContext = {
        let coodinator = self.persistentStoreCoodinator
        let managerObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managerObjectContext.persistentStoreCoordinator = coodinator
        return managerObjectContext
    }()
    
    func saveContext() {
        if managerObjectContext.hasChanges {
            do{
                try managerObjectContext.save()
            }catch {
                print(error)
                abort()
            }
        }
    }
}
