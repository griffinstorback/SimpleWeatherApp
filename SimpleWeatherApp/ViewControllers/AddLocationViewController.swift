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
    }
    
    @objc func doneButtonPressed() {
        self.dismiss(animated: true)
    }
}
