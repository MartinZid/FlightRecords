//
//  RecordsTableViewController.swift
//  FlightRecords
//
//  Created by Martin Zid on 12/10/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//

import UIKit

class RecordsTableViewController: UITableViewController, SearchViewControllerDelegate {
    
    @IBOutlet var headerView: UIView!
    
    private let viewModel = RecordsViewModel()
    
    private struct Identifiers {
        static let searchSegueIdentifier = "search"
        static let recordCellIdentifier = "RecordCell"
        static let addFlightRecordSB = "addFlightRecord"
        static let addSimulatorRecordSB = "addSimulatorRecord"
        static let pdfSegueIdentifier = "PDF"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        tableView.tableHeaderView = nil
    }
    
    private func bindViewModel() {
        viewModel.searchConfigurationChangedSignal.observeValues { [weak self] value in
            self?.tableView.tableHeaderView = (value) ? nil : self?.headerView
        }
        observeSignalForTableDataChanges(with: viewModel.collectionChangedSignal)
    }
    
    // MARK: - Actions
    
    @IBAction func disableFilters(_ sender: UIButton) {
        viewModel.disableFilters()
    }
    
    
    // MARK: - SearchViewControllerDelegate
    
    func apply(searchViewModel viewModel: SearchViewModel) {
        self.viewModel.apply(searchViewModel: viewModel)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.numberOfRecordsInSection() > 0 {
            deleteEmptyTableMessage()
            return viewModel.numberOfRecordsInSection()
        } else {
            if tableView.tableHeaderView == nil {
                displayEmptyTableMessage(message: NSLocalizedString("Empty records table", comment: ""),
                                         subMessage: NSLocalizedString("Add new record info", comment: ""))
            } else {
                displayEmptyTableMessage(message: NSLocalizedString("No records after filtering", comment: ""), subMessage: "")
            }
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.recordCellIdentifier, for: indexPath) as! RecordCell

        cell.viewModel = viewModel.getCellViewModel(for: indexPath)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            confirmDeleteAction { [weak self] _ in
                self?.viewModel.deleteRecord(at: indexPath)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = viewModel.getTypeOfRecord(at: indexPath)
        if  type == .flight {
            let nextViewController = UIStoryboard(name: Identifiers.addFlightRecordSB, bundle: nil).instantiateInitialViewController() as! AddFlightRecordTableViewController
            nextViewController.viewModel = viewModel.getAddFlightViewModel(for: indexPath)
            self.navigationController?.pushViewController(nextViewController, animated: true)
        } else if type == .simulator {
            let nextViewController = UIStoryboard(name: Identifiers.addSimulatorRecordSB, bundle: nil).instantiateInitialViewController() as! AddSimulatorRecordTableViewController
            nextViewController.viewModel = viewModel.getAddSimulatorViewModel(for: indexPath)
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Identifiers.searchSegueIdentifier {
            if let searchVC = segue.destination.contentViewController as? SearchViewController {
                searchVC.delegate = self
                searchVC.viewModel = viewModel.getSearchViewModel()
            }
        }
        if segue.identifier == Identifiers.pdfSegueIdentifier {
            if let pdfVC = segue.destination.contentViewController as? PDFGeneratorViewController {
                pdfVC.viewModel = viewModel.getPDFGeneratorViewModel()
            }
        }
    }

}
