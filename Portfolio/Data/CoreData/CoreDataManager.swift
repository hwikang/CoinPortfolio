//
//  CoreDataManager.swift
//  Portfolio
//
//  Created by paytalab on 7/26/24.
//

import Foundation
import CoreData

public class CoreDataManager {
    public static let shared = CoreDataManager()

    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
      
        let container = NSPersistentContainer(name: "Portfolio")

        let storeURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("Portfolio.sqlite")
        let description = NSPersistentStoreDescription(url: storeURL)
        description.setOption(true as NSNumber, forKey: NSMigratePersistentStoresAutomaticallyOption)
        description.setOption(true as NSNumber, forKey: NSInferMappingModelAutomaticallyOption)
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    public var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
}
