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

        let storeDescription = container.persistentStoreDescriptions.first
        storeDescription?.shouldMigrateStoreAutomatically = true
        storeDescription?.shouldInferMappingModelAutomatically = true

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
