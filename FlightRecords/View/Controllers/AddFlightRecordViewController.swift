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

class AddFlightRecordTableViewController: UITableViewController, NoteViewControllerDelegate {
    
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
    
    private let viewModel = AddFlightRecordViewModel()
    private let dateFormatter = DateFormatter()
    
    private let noteSegueIdentifier = "note"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    func bindViewModel() {
        dateTextField.reactive.text <~ viewModel.dateString
        fromTextField.reactive.text <~ viewModel.from
        timeTKOField.reactive.text <~ viewModel.timeTKOString
        toTextField.reactive.text <~ viewModel.to
        timeLDGField.reactive.text <~ viewModel.timeLDGString
        planeLabel.reactive.text <~ viewModel.plane
        totalTimeLabel.reactive.text <~ viewModel.totalTime
        picTextField.reactive.text <~ viewModel.pic
        
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
    
    private func assingUIDatePicker(to textField: UITextField, with mode: UIDatePickerMode) -> UIDatePicker {
        let datePickerView: UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = mode
        textField.inputView = datePickerView
        return datePickerView
    }
    
    private func bind(datepicker: UIDatePicker, to property: MutableProperty<Date>) {
        property <~ datepicker.reactive.mapControlEvents(UIControlEvents.valueChanged) { datePicker in datePicker.date }
    }
    
    private func setZeroTime(to datePicker: UIDatePicker) {
        datePicker.date = dateFormatter.createDate(hours: 0, minutes: 0)
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
        bind(datepicker: datePicker, to: viewModel.timeNight)
    }
    
    @IBAction func timeIFRFieldEditing(_ sender: UITextField) {
        let datePicker = assingUIDatePicker(to: sender, with: UIDatePickerMode.time)
        setZeroTime(to: datePicker)
        bind(datepicker: datePicker, to: viewModel.timeIFR)
    }
    
    @IBAction func timePICFieldEditing(_ sender: UITextField) {
        let datePicker = assingUIDatePicker(to: sender, with: UIDatePickerMode.time)
        setZeroTime(to: datePicker)
        bind(datepicker: datePicker, to: viewModel.timePIC)
    }
    
    @IBAction func timeCOFieldEditing(_ sender: UITextField) {
        let datePicker = assingUIDatePicker(to: sender, with: UIDatePickerMode.time)
        setZeroTime(to: datePicker)
        bind(datepicker: datePicker, to: viewModel.timeCO)
    }
    
    @IBAction func timeDUALFieldEditing(_ sender: UITextField) {
        let datePicker = assingUIDatePicker(to: sender, with: UIDatePickerMode.time)
        setZeroTime(to: datePicker)
        bind(datepicker: datePicker, to: viewModel.timeDual)
    }
    
    @IBAction func timeInstructorFieldEditing(_ sender: UITextField) {
        let datePicker = assingUIDatePicker(to: sender, with: UIDatePickerMode.time)
        setZeroTime(to: datePicker)
        bind(datepicker: datePicker, to: viewModel.timeInstructor)
    }
    
    func save(note: String) {
        viewModel.note.value = note
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == noteSegueIdentifier {
            if let noteVC = segue.destination.contentViewController as? NoteViewController {
                noteVC.delegate = self
                noteVC.note = viewModel.note.value
            }
        }
    }

}
