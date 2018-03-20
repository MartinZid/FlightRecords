//
//  UIDatePickerDelegateViewController.swift
//  FlightRecords
//
//  Created by Martin Zid on 16/11/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//

import UIKit
import ReactiveSwift

/**
 Class with helper methods for form TableViewControllers.
 */
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
    
    internal func bind(datepicker: UIDatePicker, to property: MutableProperty<Date?>) {
        property <~ datepicker.reactive.mapControlEvents(UIControlEvents.valueChanged) { datePicker in datePicker.date }
    }
    
    internal func setZeroTime(to datePicker: UIDatePicker) {
        datePicker.date = dateFormatter.createDate(hours: 0, minutes: 0)
    }
    
    internal func setMax(time string: String, to datePicker: UIDatePicker) {
        datePicker.maximumDate = dateFormatter.createTime(from: string)
    }
    
    /**
     It sets UIDatePicker as inputView to sender with UIDatePickerMode. It also binds this datePicker's value to MutableProperty.
     MutableProperty's value is also set to datePicker.
     
     If sender has already set inputView, this function doesn't change it. It just returns it.
     
     - Parameter sender: UITextField
     - Parameter mode: UIDatePickerMode
     - Parameter property: MutableProperty<Date>
     */
    internal func handleDatePicker(for sender: UITextField, with mode: UIDatePickerMode,
                                   and property: MutableProperty<Date>) -> UIDatePicker {
        if sender.inputView == nil {
            let datePicker = assingUIDatePicker(to: sender, with: mode)
            bind(datepicker: datePicker, to: property)
            datePicker.date = property.value
            return datePicker
        }
        return sender.inputView as! UIDatePicker
    }
    
    /**
     It sets UIDatePicker as inputView to sender with UIDatePickerMode. It also binds this datePicker's value to MutableProperty.
     
     When MutableProperty has not nil value, it's value is set to datePicker, otherwise if default value is not nil, then default value is set to datePicker.
     
     If sender has already set inputView, this function doesn't change it. It just returns it.
     
     - Parameter sender: UITextField
     - Parameter mode: UIDatePickerMode
     - Parameter property: MutableProperty<Date?>
     - Parameter defaultValue: Date?
    */
    internal func handleDatePicker(for sender: UITextField, with mode: UIDatePickerMode,
                                   and property: MutableProperty<Date?>, default defaultValue: Date? ) -> UIDatePicker {
        if sender.inputView == nil {
            let datePicker = assingUIDatePicker(to: sender, with: mode)
            bind(datepicker: datePicker, to: property)
            if let value = property.value {
                datePicker.date = value
            } else if let value = defaultValue {
                property.value = value
                datePicker.date = value
            }
            return datePicker
        }
        return sender.inputView as! UIDatePicker
    }

}
