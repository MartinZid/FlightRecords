//
//  PlanesTableViewController.swift
//  FlightRecords
//
//  Created by Martin Zid on 02/11/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//

import UIKit

/**
    PlanesTableViewController displays all user's planes in table.
 */
class PlanesTableViewController: UITableViewController {
    
    private let planeCellIdentifier = "PlaneCell"
    private let viewModel = PlanesViewModel()
    
    var delegate: PlanesTableViewControllerDelegate? = nil
    
    private var selectedPlaneViewModel: PlaneViewModel!
    
    private struct Identifiers {
        static let addPlane = "addPlane"
        static let selectPlane = "planeSelected"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.contentChangedSignal.observeValues {
            print("Reloading data")
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfPlanesInSection()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: planeCellIdentifier, for: indexPath) as! PlaneCell
        
        cell.viewModel = viewModel.getCellViewModel(for: indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    // MARK: - Navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPlaneViewModel = viewModel.getCellViewModel(for: indexPath)
        delegate?.userDidSelect(planeViewModel: selectedPlaneViewModel)
        self.navigationController?.popViewController(animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Identifiers.addPlane {
            if let addPlaneVC = segue.destination.contentViewController as? AddPlaneViewController {
                addPlaneVC.viewModel = viewModel.addPlaneViewModelForNewPlane()
            }
        }
    }

}
