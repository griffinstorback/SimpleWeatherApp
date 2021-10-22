//
//  NetworkManager.swift
//  SimpleWeatherApp
//
//  Created by Griffin Storback on 2021-07-25.
//

import Foundation

// abstract the network manager behind an interface (for mock-testing, and cleanliness)
protocol NetworkManagerProtocol {
    func getWeatherForLocation(id: Int, completion: @escaping (Result<Weather,Error>) -> Void)
}

class NetworkManager: NetworkManagerProtocol {
    static let shared = NetworkManager()
    
    private init() { }
    
    // TODO: Make Weather model (CURRENTLY IS DUMMY OBJECT IN Location.swift)
    func getWeatherForLocation(id: Int, completion: @escaping (Result<Weather,Error>) -> Void) {
        NetworkHelper.getDataFromEndPointHandleResponseAndDecodeData(decodeTo: Weather.self, endPoint: EndPoint.weather(id: id)) { result in
            switch result {
            case .success(let weather):
                completion(.success(weather))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        // OR, to simplify the above lines even further (BUT I believe this way is harder to read):
        // NetworkHelper.getDataFromEndPointHandleResponseAndDecodeData(decodeTo: Weather.self, endPoint: EndPoint.weather(id: id), completion: completion)
    }
    
    func getLocationsForSearchText(_ searchText: String, completion: @escaping (Result<[Location],Error>) -> Void) {
        // use metaweather api
    }
    
    
    
}
