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

class AddFlightRecordTableViewController: UITableViewController {
    
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
    
    private let viewModel = AddFlightRecordViewModel()
    
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
    }
    
    private func createUIDatePicker() -> UIDatePicker {
        let datePickerView: UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        return datePickerView
    }
    
    private func bind(datepicker: UIDatePicker, to property: MutableProperty<Date>) {
        property <~ datepicker.reactive.mapControlEvents(UIControlEvents.valueChanged) { datePicker in datePicker.date }
    }
    
    @IBAction func dateFieldEditing(_ sender: UITextField) {
        let datePicker: UIDatePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePicker
        bind(datepicker: datePicker, to: viewModel.date)
    }
    
    @IBAction func timeTKOFieldEditing(_ sender: UITextField) {
        let datePicker: UIDatePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePickerMode.time
        sender.inputView = datePicker
        bind(datepicker: datePicker, to: viewModel.timeTKO)
    }
    
    @IBAction func timeLDGFieldEditing(_ sender: UITextField) {
        let datePicker: UIDatePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePickerMode.time
        sender.inputView = datePicker
        bind(datepicker: datePicker, to: viewModel.timeLDG)
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
