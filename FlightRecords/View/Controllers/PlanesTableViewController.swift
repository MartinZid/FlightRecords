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
    
    private let viewModel = PlanesViewModel()
    
    var delegate: PlanesTableViewControllerDelegate? = nil
    
    private var selectedPlaneViewModel: PlaneViewModel!
    
    private struct Identifiers {
        static let addPlane = "addPlane"
        static let selectPlane = "planeSelected"
        static let planeCellIdentifier = "PlaneCell"
        static let planesSB = "planes"
        static let addPlaneVC = "addPlaneVC"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    private func bindViewModel() {
        observeSignalForTableDataChanges(with: viewModel.collectionChangedSignal)
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfPlanesInSection()
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return delegate == nil
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deletePlane(at: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.planeCellIdentifier, for: indexPath) as! PlaneCell
        
        cell.viewModel = viewModel.getCellViewModel(for: indexPath)
        if delegate != nil { // user is selecting plane
            cell.accessoryType = .none
        } else { // user is managing all planes
            cell.accessoryType = .disclosureIndicator
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    // MARK: - Navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if delegate != nil { // user is selecting plane (pass it to delegate)
            selectedPlaneViewModel = viewModel.getCellViewModel(for: indexPath)
            delegate?.userDidSelect(planeViewModel: selectedPlaneViewModel)
            self.navigationController?.popViewController(animated: true)
        } else { // user is managing planes (show him detail)
            let nextViewController = UIStoryboard(name: Identifiers.planesSB, bundle: nil).instantiateViewController(withIdentifier: Identifiers.addPlaneVC) as! AddPlaneViewController
            nextViewController.viewModel = viewModel.addPlaneViewModelForPlane(at: indexPath)
            let navigationController = UINavigationController(rootViewController: nextViewController)
            self.navigationController?.present(navigationController, animated: true, completion: nil)
            //self.navigationController?.pushViewController(nextViewController, animated: true)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Identifiers.addPlane {
            if let addPlaneVC = segue.destination.contentViewController as? AddPlaneViewController {
                addPlaneVC.viewModel = viewModel.addPlaneViewModelForNewPlane()
            }
        }
    }

}
