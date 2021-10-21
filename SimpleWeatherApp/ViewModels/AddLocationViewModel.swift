//
//  AddLocationViewModel.swift
//  SimpleWeatherApp
//
//  Created by Griffin Storback on 2021-08-03.
//

import Foundation

class AddLocationViewModel: ObservableObject {
    /// Shows queried locations (queried using searchText)
    @Published var displayedLocations: [Location] = []
    
    @Published var searchText: String = ""
}
