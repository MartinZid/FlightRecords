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
        viewModel.planesChangedSignal.observeValues{ [weak self] changes in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                     with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.endUpdates()
            case .error(let error):
                fatalError("\(error)")
            }
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
