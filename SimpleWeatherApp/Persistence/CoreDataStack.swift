//
//  CoreDataStack.swift
//  SimpleWeatherApp
//
//  Created by Griffin Storback on 2021-10-26.
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    private init() { }
    
    static let persistentContainerName = "SimpleWeatherAppPersistentContainer"
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: CoreDataStack.persistentContainerName)
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Error setting up persistent container in CoreDataStack: \(error)")
            }
        }
        
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    /// Returns a new ManagedObjectContext that executes on a private queue, and has mainContext as parent
    func createBackgroundContext() -> NSManagedObjectContext {
        let newContext = persistentContainer.newBackgroundContext()
        newContext.parent = mainContext
        return newContext
    }
    
    func saveContext(_ context: NSManagedObjectContext? = nil) {
        let context = context ?? persistentContainer.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context in CoreDataStack: \(error)")
            }
        }
    }
}
