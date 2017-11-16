//
//  AddFlightRecordViewController.swift
//  FlightRecords
//
//  Created by Martin Zid on 18/10/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift

class AddFlightRecordTableViewController: RecordTableViewController,
    NoteViewControllerDelegate,
    PlanesTableViewControllerDelegate {
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var timeTKOField: UITextField!    
    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var timeLDGField: UITextField!
    @IBOutlet weak var planeLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var picTextField: UITextField!
    
    @IBOutlet weak var tkoDayStepper: UIStepper!
    @IBOutlet weak var tkoDayLabel: UILabel!
    @IBOutlet weak var tkoNightStepper: UIStepper!
    @IBOutlet weak var tkoNightLabel: UILabel!
    
    @IBOutlet weak var ldgDayStepper: UIStepper!
    @IBOutlet weak var ldgDayLabel: UILabel!
    @IBOutlet weak var ldgNightStepper: UIStepper!
    @IBOutlet weak var ldgNightLabel: UILabel!
    
    @IBOutlet weak var timeNightField: UITextField!
    @IBOutlet weak var timeIFRField: UITextField!
    @IBOutlet weak var timePICField: UITextField!
    @IBOutlet weak var timeCOField: UITextField!
    @IBOutlet weak var timeDualField: UITextField!
    @IBOutlet weak var timeInstructorField: UITextField!
    
    @IBOutlet weak var noteLabel: UILabel!
    
    var viewModel: AddFlightRecordViewModel!
    private let dateFormatter = DateFormatter()
    
    private struct Identifiers {
        static let noteSegueIdentifier = "note"
        static let planesSegueIdentifier = "plane"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if viewModel == nil {
            viewModel = AddFlightRecordViewModel(with: nil)
        }
        bindViewModel()
    }
    
    func bindViewModel() {
        dateTextField.reactive.text <~ viewModel.dateString
        viewModel.from <~ toTextField.reactive.continuousTextValues.filterMap{ $0 }
        timeTKOField.reactive.text <~ viewModel.timeTKOString
        viewModel.to <~ fromTextField.reactive.continuousTextValues.filterMap{ $0 }
        timeLDGField.reactive.text <~ viewModel.timeLDGString
        planeLabel.reactive.text <~ viewModel.planeString
        totalTimeLabel.reactive.text <~ viewModel.totalTime
        viewModel.pic <~ picTextField.reactive.continuousTextValues.filterMap{ $0 }
        
        viewModel.tkoDay <~ tkoDayStepper.reactive.values
        viewModel.tkoNight <~ tkoNightStepper.reactive.values
        viewModel.ldgDay <~ ldgDayStepper.reactive.values
        viewModel.ldgNight <~ ldgNightStepper.reactive.values
        
        tkoDayLabel.reactive.text <~ viewModel.tkoDayString
        tkoNightLabel.reactive.text <~ viewModel.tkoNightString
        ldgDayLabel.reactive.text <~ viewModel.ldgDayString
        ldgNightLabel.reactive.text <~ viewModel.ldgNightString
        
        timeNightField.reactive.text <~ viewModel.timeNightString
        timeIFRField.reactive.text <~ viewModel.timeIFRString
        timePICField.reactive.text <~ viewModel.timePICString
        timeCOField.reactive.text <~ viewModel.timeCOString
        timeDualField.reactive.text <~ viewModel.timeDualString
        timeInstructorField.reactive.text <~ viewModel.timeInstructorString
        
        noteLabel.reactive.text <~ viewModel.note
    }
    
    // MARK: - UIDatePickers initialization
    
    private func setMaxTimeOnSignal(to datePicker: UIDatePicker) {
        setMax(time: viewModel.totalTime.value, to: datePicker)
        viewModel.totalTime.signal.observeValues{time in
            self.setMax(time: time, to: datePicker)
        }
    }
    
    @IBAction func dateFieldEditing(_ sender: UITextField) {
        let datePicker = assingUIDatePicker(to: sender, with: UIDatePickerMode.date)
        bind(datepicker: datePicker, to: viewModel.date)
    }
    
    @IBAction func timeTKOFieldEditing(_ sender: UITextField) {
        let datePicker = assingUIDatePicker(to: sender, with: UIDatePickerMode.time)
        bind(datepicker: datePicker, to: viewModel.timeTKO)
    }
    
    @IBAction func timeLDGFieldEditing(_ sender: UITextField) {
        let datePicker = assingUIDatePicker(to: sender, with: UIDatePickerMode.time)
        bind(datepicker: datePicker, to: viewModel.timeLDG)
    }
    
    @IBAction func timeNightFieldEditing(_ sender: UITextField) {
        let datePicker = assingUIDatePicker(to: sender, with: UIDatePickerMode.time)
        setZeroTime(to: datePicker)
        setMaxTimeOnSignal(to: datePicker)
        bind(datepicker: datePicker, to: viewModel.timeNight)
    }
    
    @IBAction func timeIFRFieldEditing(_ sender: UITextField) {
        let datePicker = assingUIDatePicker(to: sender, with: UIDatePickerMode.time)
        setZeroTime(to: datePicker)
        setMaxTimeOnSignal(to: datePicker)
        bind(datepicker: datePicker, to: viewModel.timeIFR)
    }
    
    @IBAction func timePICFieldEditing(_ sender: UITextField) {
        let datePicker = assingUIDatePicker(to: sender, with: UIDatePickerMode.time)
        setZeroTime(to: datePicker)
        setMaxTimeOnSignal(to: datePicker)
        bind(datepicker: datePicker, to: viewModel.timePIC)
    }
    
    @IBAction func timeCOFieldEditing(_ sender: UITextField) {
        let datePicker = assingUIDatePicker(to: sender, with: UIDatePickerMode.time)
        setZeroTime(to: datePicker)
        setMaxTimeOnSignal(to: datePicker)
        bind(datepicker: datePicker, to: viewModel.timeCO)
    }
    
    @IBAction func timeDUALFieldEditing(_ sender: UITextField) {
        let datePicker = assingUIDatePicker(to: sender, with: UIDatePickerMode.time)
        setZeroTime(to: datePicker)
        setMaxTimeOnSignal(to: datePicker)
        bind(datepicker: datePicker, to: viewModel.timeDual)
    }
    
    @IBAction func timeInstructorFieldEditing(_ sender: UITextField) {
        let datePicker = assingUIDatePicker(to: sender, with: UIDatePickerMode.time)
        setZeroTime(to: datePicker)
        setMaxTimeOnSignal(to: datePicker)
        bind(datepicker: datePicker, to: viewModel.timeInstructor)
    }
    @IBAction func saveRecordToRealm(_ sender: Any) {
        viewModel.saveRecordToRealm()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func save(note: String) {
        viewModel.note.value = note
    }
    
    func userDidSelect(planeViewModel: PlaneViewModel) {
        viewModel.setPlane(from: planeViewModel)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Identifiers.noteSegueIdentifier {
            if let noteVC = segue.destination.contentViewController as? NoteViewController {
                noteVC.delegate = self
                noteVC.note = viewModel.note.value
            }
        }
        if segue.identifier == Identifiers.planesSegueIdentifier {
            if let planesVC = segue.destination.contentViewController as? PlanesTableViewController {
                planesVC.delegate = self
            }
        }
    }

}
