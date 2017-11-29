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

class AddSimulatorRecordTableViewController: RecordTableViewController, NoteViewControllerDelegate {
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var noteLabel: UILabel!
    
    var viewModel: AddSimulatorRecordViewModel!
    
    private struct Identifiers {
        static let noteSegueIdentifier = "note"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if viewModel == nil {
            viewModel = AddSimulatorRecordViewModel(with: nil)
        }
        bindViewModel()
        setEndEditingOnTap()
    }
    
    func bindViewModel() {
        self.title = viewModel.title
        
        typeTextField.text = viewModel.type.value
        
        dateTextField.reactive.text <~ viewModel.dateString
        timeTextField.reactive.text <~ viewModel.timeString
        viewModel.type <~ typeTextField.reactive.continuousTextValues.filterMap{ $0 }
        noteLabel.reactive.text <~ viewModel.note
    }
    
    @IBAction func dateFieldEditing(_ sender: UITextField) {
        let datePicker = assingUIDatePicker(to: sender, with: .date)
        bind(datepicker: datePicker, to: viewModel.date)
    }
    
    @IBAction func timeFieldEditing(_ sender: UITextField) {
        let datePicker = assingUIDatePicker(to: sender, with: .time)
        setZeroTime(to: datePicker)
        bind(datepicker: datePicker, to: viewModel.time)
    }
    
    
    @IBAction func saveRecordToRealm(_ sender: Any) {
        viewModel.saveRecordToRealm()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func save(note: String) {
        print(note)
        viewModel.note.value = note
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
