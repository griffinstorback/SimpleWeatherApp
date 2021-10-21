//
//  LocationsViewModel.swift
//  SimpleWeatherApp
//
//  Created by Griffin Storback on 2021-07-25.
//

import Foundation

class LocationsViewModel: ObservableObject {
    @Published var savedLocations: [Location] = []
    
    init() {
        loadSavedLocations()
    }
    
    private func loadSavedLocations() {
        
    }
}
