//
//  NetworkManager.swift
//  SimpleWeatherApp
//
//  Created by Griffin Storback on 2021-07-25.
//

import Foundation

// abstract the network manager behind an interface (for mock-testing, and cleanliness)
protocol NetworkManagerProtocol {
    func getWeatherForLocation()
}

class NetworkManager: NetworkManagerProtocol {
    static let shared = NetworkManager()
    
    private init() { }
    
    func getWeatherForLocation() {
        print("nothing for now")
    }
    
    func getLocationsForSearchText(_ searchText: String, completion: @escaping (Result<[Location],Error>) -> Void) {
        // use metaweather api
    }
}
