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
    
    func mirgationData(option : NSDictionary?){
        
    }
    
    lazy var applicationDocumentDirectory : NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count - 1]
    }()
    
    lazy var managerObjectModel : NSManagedObjectModel = {
        let modelURL = NSBundle.mainBundle().URLForResource("Model", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoodinator : NSPersistentStoreCoordinator? = {
        let coodinator : NSPersistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managerObjectModel)
        let url =  self.applicationDocumentDirectory.URLByAppendingPathComponent(SQLite_File_Name)
        do {
            try coodinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: self.options)
        }catch {
            abort()
        }
        return coodinator
    }()
    
    lazy var managerObjectContext : NSManagedObjectContext = {
        let coodinator = self.persistentStoreCoodinator
        let managerObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
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
