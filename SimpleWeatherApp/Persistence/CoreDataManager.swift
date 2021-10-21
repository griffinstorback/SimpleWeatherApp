//
//  CoreDataManager.swift
//  SimpleWeatherApp
//
//  Created by Griffin Storback on 2021-07-25.
//

import Foundation

protocol CoreDataManagerProtocol {
    
}

class CoreDataManager: CoreDataManagerProtocol {
    static let shared = CoreDataManager()
    
    private init() { }
}
