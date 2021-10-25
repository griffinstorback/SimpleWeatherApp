//
//  AddLocationViewController.swift
//  SimpleWeatherApp
//
//  Created by Griffin Storback on 2021-07-25.
//

import UIKit

/// "Add location" modal, presented from "+" in LocationsTableView rightBarButtonItem
class AddLocationViewController: UIViewController {
    let viewModel: AddLocationViewModel
    
    private let searchController: UISearchController
    private let resultsTableView: UITableViewController
    private let resultsTableViewDataSource: UITableViewDiffableDataSource<Int, Int>
    
    init(viewModel: AddLocationViewModel = AddLocationViewModel()) {
        self.viewModel = viewModel
        
        resultsTableView = UITableViewController(style: .plain)
        
        // set up resultsTableView DataSource
        resultsTableViewDataSource = UITableViewDiffableDataSource<Int, Int>(tableView: resultsTableView.tableView, cellProvider: { tableView, indexPath, section -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "LocationResultCell", for: indexPath) as UITableViewCell
            
            return UITableViewCell()
        })
        
        searchController = UISearchController(searchResultsController: resultsTableView)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Add location"
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonPressed))
        navigationItem.searchController = searchController
        
        searchController.searchResultsUpdater = self
        resultsTableView
    }
    
    @objc func doneButtonPressed() {
        self.dismiss(animated: true)
    }
}

extension AddLocationViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let changedSearchText = searchController.searchBar.text else { return }
        viewModel.searchText.send(changedSearchText)
    }
}
