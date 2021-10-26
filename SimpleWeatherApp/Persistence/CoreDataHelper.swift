//
//  CoreDataHelper.swift
//  SimpleWeatherApp
//
//  Created by Griffin Storback on 2021-10-26.
//

import Foundation
import CoreData

struct CoreDataHelper {
    
    static func log(error: Error) {
        print("Core Data error: \(error)")
    }
    
    static func logCallstack() {
        print("Callstack: ")
        for symbol: String in Thread.callStackSymbols {
            print(" > \(symbol)")
        }
    }
    
    /// Fetch multiple objects of type 'entity'
    static func fetchObjects<T: NSManagedObject>(entity: T.Type, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil, fetchBatchSize: Int = 0, context: NSManagedObjectContext) -> [T] {
        let request = NSFetchRequest<T>(entityName: String(describing: entity))
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        request.fetchBatchSize = fetchBatchSize
        
        do {
            return try context.fetch(request)
        } catch {
            log(error: error)
            return [T]()
        }
    }
    
    /// Fetch single object of type 'entity'
    static func fetchObject<T: NSManagedObject>(entity: T.Type, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil, context: NSManagedObjectContext) -> T? {
        let request = NSFetchRequest<T>(entityName: String(describing: entity))
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        request.fetchLimit = 1
        
        do {
            return try context.fetch(request).first
        } catch {
            log(error: error)
            return nil
        }
    }
}
