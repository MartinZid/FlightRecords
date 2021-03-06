//
//  AddSimulatorRecordTableViewController.swift
//  FlightRecords
//
//  Created by Martin Zid on 16/11/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

/**
 A form like UITableViewController for creating/editing a simulator record.
 */
class AddSimulatorRecordTableViewController: RecordTableViewController, NoteViewControllerDelegate {
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var noteLabel: UILabel!
    
    var viewModel: AddSimulatorRecordViewModel!
    
    private struct Identifiers {
        static let noteSegueIdentifier = "note"
    }
    
    // MARK: - Controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if viewModel == nil {
            viewModel = AddSimulatorRecordViewModel(with: nil)
        }
        bindViewModel()
        setEndEditingOnTap()
    }
    
    // MARK: - Bindings
    
    private func bindViewModel() {
        self.title = viewModel.title
        
        typeTextField.text = viewModel.type.value
        
        dateTextField.reactive.text <~ viewModel.dateString
        timeTextField.reactive.text <~ viewModel.timeString
        viewModel.type <~ typeTextField.reactive.continuousTextValues.filterMap{ $0 }
        noteLabel.reactive.text <~ viewModel.note
    }
    
    // MARK: - Actions
    
    @IBAction func dateFieldEditing(_ sender: UITextField) {
        _ = handleDatePicker(for: sender, with: .date, and: viewModel.date)
    }
    
    @IBAction func timeFieldEditing(_ sender: UITextField) {
        _ = handleDatePicker(for: sender, with: .time, and: viewModel.time)
    }
    
    
    @IBAction func saveRecordToRealm(_ sender: Any) {
        viewModel.saveRecordToRealm()
        if let navController = splitViewController?.viewControllers[0] as? UINavigationController {
            navController.popToRootViewController(animated: true)
        }
    }
    
    // MARK: - NoteViewControllerDelegate
    
    func save(note: String) {
        viewModel.note.value = note
    }
    
    // MARK: - UITableView data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: dateTextField.becomeFirstResponder()
        case 1: timeTextField.becomeFirstResponder()
        case 2: typeTextField.becomeFirstResponder()
        default: break
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Identifiers.noteSegueIdentifier {
            if let noteVC = segue.destination.contentViewController as? NoteViewController {
                noteVC.delegate = self
                noteVC.note = viewModel.note.value
            }
        }
    }

}
