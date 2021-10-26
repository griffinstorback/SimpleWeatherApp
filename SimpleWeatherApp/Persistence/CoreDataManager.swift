//
//  CoreDataManager.swift
//  SimpleWeatherApp
//
//  Created by Griffin Storback on 2021-07-25.
//

import Foundation
import CoreData

protocol CoreDataManagerProtocol {
    
}

class CoreDataManager: CoreDataManagerProtocol {
    static let shared = CoreDataManager()
    private init() { }
    
    let coreDataStack = CoreDataStack.shared
    
    func createOrUpdateLocation(location: Location, context: NSManagedObjectContext? = nil) -> LocationMO {
        let context = context ?? coreDataStack.mainContext
        let locationMO = CoreDataHelper.fetchObject(entity: LocationMO.self, context: context) ?? {
            let newLocationMO = LocationMO(context: context)
            newLocationMO.woeid = Int32(location.woeid)
            return newLocationMO
        }()
        
        locationMO.title = location.title
        locationMO.locationType = location.locationType
        locationMO.latitude = location.latLong.0
        locationMO.longitude = location.latLong.1
        
        coreDataStack.saveContext(context)
        return locationMO
    }
}
