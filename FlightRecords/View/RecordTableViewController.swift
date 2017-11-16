//
//  UIDatePickerDelegateViewController.swift
//  FlightRecords
//
//  Created by Martin Zid on 16/11/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//

import UIKit
import ReactiveSwift

class RecordTableViewController: UITableViewController {
    
    private let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    internal func assingUIDatePicker(to textField: UITextField, with mode: UIDatePickerMode) -> UIDatePicker {
        let datePickerView: UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = mode
        textField.inputView = datePickerView
        return datePickerView
    }
    
    internal func bind(datepicker: UIDatePicker, to property: MutableProperty<Date>) {
        property <~ datepicker.reactive.mapControlEvents(UIControlEvents.valueChanged) { datePicker in datePicker.date }
    }
    
    internal func setZeroTime(to datePicker: UIDatePicker) {
        datePicker.date = dateFormatter.createDate(hours: 0, minutes: 0)
    }
    
    /**
     - Parameter time: String in format HH:mm
     - Parameter datePicker: UIDatePicker
     */
    internal func setMax(time: String, to datePicker: UIDatePicker) {
        let timeArray = time.components(separatedBy: ":")
        datePicker.maximumDate = dateFormatter.createDate(hours: Int(timeArray[0])!, minutes: Int(timeArray[1])!)
    }

}
