//
//  RecordsTableViewController.swift
//  FlightRecords
//
//  Created by Martin Zid on 12/10/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//

import UIKit

/**
    RecordsTableViewController displays all flight records in table.
 */
class RecordsTableViewController: UITableViewController {
    
    private let recordCellIdentifier = "RecordCell"
    private let viewModel = RecordsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.contentChangedSignal.observeValues {
            print("Reloading data")
            self.tableView.reloadData()
        }
//        viewModel.recordsChangedSignal.observeValues{ [weak self] changes in
//            print("records changed...")
//            guard let tableView = self?.tableView else { return }
//            switch changes {
//            case .initial:
//                tableView.reloadData()
//            case .update(_, let deletions, let insertions, let modifications):
//                tableView.beginUpdates()
//                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
//                                     with: .automatic)
//                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
//                                     with: .automatic)
//                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
//                                     with: .automatic)
//                tableView.endUpdates()
//            case .error(let error):
//                fatalError("\(error)")
//            }
//        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRecordsInSection()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: recordCellIdentifier, for: indexPath) as! RecordCell

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
            self.tableView.beginUpdates()
            viewModel.deleteRecord(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.endUpdates()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = viewModel.getTypeOfRecord(at: indexPath)
        if  type == .flight {
            let nextViewController = UIStoryboard(name: "addFlightRecord", bundle: nil).instantiateInitialViewController() as! AddFlightRecordTableViewController
            nextViewController.viewModel = viewModel.getAddFlightViewModel(for: indexPath)
            self.navigationController?.pushViewController(nextViewController, animated: true)
        } else if type == .simulator {
            let nextViewController = UIStoryboard(name: "addSimulatorRecord", bundle: nil).instantiateInitialViewController() as! AddSimulatorRecordTableViewController
            nextViewController.viewModel = viewModel.getAddSimulatorViewModel(for: indexPath)
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
