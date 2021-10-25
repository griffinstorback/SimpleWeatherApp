//
//  AddLocationViewController.swift
//  SimpleWeatherApp
//
//  Created by Griffin Storback on 2021-07-25.
//

import UIKit

/// "Add location" modal, presented from "+" in LocationsTableView rightBarButtonItem
class AddLocationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Add location"
        view.backgroundColor = .systemTeal
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonPressed))
        
        NetworkManager.shared.getLocationsForSearchText("san") { result in
            switch result {
            case .failure(let error):
                print("error getting locations in AddLocationVC:", error)
            case .success(let locations):
                print(locations)
            }
        }
    }
    
    @objc func doneButtonPressed() {
        self.dismiss(animated: true)
    }
}
