//
//  AddLocationViewController.swift
//  SimpleWeatherApp
//
//  Created by Griffin Storback on 2021-07-25.
//

import UIKit
import Combine

/// "Add location" modal, presented from "+" in LocationsTableView rightBarButtonItem
class AddLocationViewController: UIViewController {
    let viewModel: AddLocationViewModel
    var cancellables = Set<AnyCancellable>()
    
    private let searchController: UISearchController
    private let resultsTableView: UITableViewController
    private var resultsTableViewDataSource: UITableViewDiffableDataSource<Int, Location>?
    
    init(viewModel: AddLocationViewModel = AddLocationViewModel()) {
        self.viewModel = viewModel
        
        resultsTableView = UITableViewController(style: .plain)
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
        
        resultsTableView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "LocationResultCell")
        resultsTableView.tableView.delegate = self
        
        // set up results table view data source
        resultsTableViewDataSource = UITableViewDiffableDataSource<Int, Location>(tableView: resultsTableView.tableView, cellProvider: { tableView, indexPath, location -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "LocationResultCell", for: indexPath) as UITableViewCell
            cell.textLabel?.text = location.title
            cell.imageView?.image = UIImage(systemName: "location")
            return cell
        })
        
        setupLocationsObserver()
    }
    
    private func layoutViews() {
        //view.addSubview(resultsTableView.tableView)
    }
    
    @objc func doneButtonPressed() {
        self.dismiss(animated: true)
    }
    
    func setupLocationsObserver() {
        viewModel.displayedLocations.receive(on: DispatchQueue.main).sink { [weak self] locations in
            var snapshot = NSDiffableDataSourceSnapshot<Int, Location>()
            snapshot.appendSections([0])
            snapshot.appendItems(locations, toSection: 0)
            self?.resultsTableViewDataSource?.apply(snapshot, animatingDifferences: true)
        }.store(in: &cancellables)
    }
}

extension AddLocationViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let changedSearchText = searchController.searchBar.text else { return }
        viewModel.searchText.send(changedSearchText)
    }
}

extension AddLocationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedLocation = resultsTableViewDataSource?.itemIdentifier(for: indexPath)
        print("selected location:", selectedLocation)
    }
}
