//
//  AddLocationViewModel.swift
//  SimpleWeatherApp
//
//  Created by Griffin Storback on 2021-08-03.
//

import Foundation
import Combine

protocol AddLocationViewModelProtocol {
    var displayedLocations: CurrentValueSubject<[Location], Never> { get }
    var searchText: CurrentValueSubject<String, Never> { get }
}

class AddLocationViewModel: AddLocationViewModelProtocol, ObservableObject {
    private let networkManager: NetworkManagerProtocol
    
    var displayedLocations = CurrentValueSubject<[Location], Never>([])
    var searchText = CurrentValueSubject<String, Never>("")
    var cancellables = [AnyCancellable]()
    
    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
        
        // when search text changed, update search results
        searchText.sink { [weak self] updatedText in
            self?.updateDisplayedLocations(text: updatedText)
        }.store(in: &cancellables)
    }
    
    private func updateDisplayedLocations(text: String) {
        // if text empty, no results (obvs)
        guard !text.isEmpty else {
            displayedLocations.send([])
            return
        }
        
        NetworkManager.shared.getLocationsForSearchText(text) { [weak self] result in
            switch result {
            case .failure(let error):
                print("error getting locations in AddLocationVC:", error)
            case .success(let locations):
                self?.displayedLocations.send(locations)
            }
        }
    }
}
