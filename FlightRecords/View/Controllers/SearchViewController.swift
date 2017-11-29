//
//  SearchViewController.swift
//  FlightRecords
//
//  Created by Martin Zid on 24/11/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift

class SearchViewController: RecordTableViewController, PlanesTableViewControllerDelegate {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var flightsSwitch: UISwitch!
    @IBOutlet weak var fstdSwitch: UISwitch!
    @IBOutlet weak var planeTypeTextField: UITextField!
    @IBOutlet weak var planeLabel: UILabel!
    
    @IBOutlet weak var fromDateTextField: UITextField!
    @IBOutlet weak var toDateTextField: UITextField!
    
    var delegate: SearchViewControllerDelegate? = nil
    
    var viewModel: SearchViewModel!
    
    private struct Identifiers {
        static let planesSegueIdentifier = "plane"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setEndEditingOnTap()
        print("view did load")
    }
    
    // MARK: - Binding
    
    private func bindViewModel() {
        setDefaultValues()
        
        viewModel.searchText <~ searchTextField.reactive.continuousTextValues.filterMap{ $0 }
        viewModel.flightsSwitch <~ flightsSwitch.reactive.isOnValues
        viewModel.fstdSwitch <~ fstdSwitch.reactive.isOnValues
        viewModel.planeType <~ planeTypeTextField.reactive.continuousTextValues.filterMap{ $0 }
        planeLabel.reactive.text <~ viewModel.planeLabel
        
        fromDateTextField.reactive.text <~ viewModel.fromDateString
        toDateTextField.reactive.text <~ viewModel.toDateString
        
    }
    
    private func setDefaultValues() {
        searchTextField.text = viewModel.searchText.value
        flightsSwitch.isOn = viewModel.flightsSwitch.value
        fstdSwitch.isOn = viewModel.fstdSwitch.value
        planeTypeTextField.text = viewModel.planeType.value
    }
    
    @IBAction func fromTextFieldEditing(_ sender: UITextField) {
        if sender.inputView == nil {
            let datepicker = assingUIDatePicker(to: sender, with: .date)
            viewModel.fromDate <~ datepicker.reactive.mapControlEvents(UIControlEvents.valueChanged) { datePicker in datePicker.date }
            if let date = viewModel.fromDate.value {
                datepicker.date = date
            } else {
                viewModel.fromDate.value = Date()
            }
        }
    }
    
    private func setMinimum(date value: Date?, to datePicker: UIDatePicker) {
        if let date = value {
            datePicker.minimumDate = date
        }
    }
    
    private func setMinDateOnSignal(to datePicker: UIDatePicker) {
        setMinimum(date: viewModel.fromDate.value, to: datePicker)
        viewModel.fromDate.signal.observeValues{ [weak self] date in
            self?.setMinimum(date: date, to: datePicker)
        }
    }
    
    @IBAction func toTextFieldEditing(_ sender: UITextField) {
        if sender.inputView == nil {
            let datepicker = assingUIDatePicker(to: sender, with: .date)
            viewModel.toDate <~ datepicker.reactive.mapControlEvents(UIControlEvents.valueChanged) { datePicker in datePicker.date }
            setMinDateOnSignal(to: datepicker)
            if let date = viewModel.toDate.value {
                datepicker.date = date
            } else {
                viewModel.setDefaultToDateValue()
            }
        }
    }
    
    private func resetDateInputTextFields() {
        fromDateTextField.inputView = nil
        toDateTextField.inputView = nil
    }
    
    @IBAction func clearSearchParameters(_ sender: Any) {
        viewModel.clearSearchParameters()
        setDefaultValues()
        resetDateInputTextFields()
    }
    
    // MARK: - Delegate functions
    
    func userDidSelect(planeViewModel: PlaneViewModel) {
        viewModel.setPlane(from: planeViewModel)
    }
    
    // MARK: - Navigation
    
    @IBAction func done(_ sender: Any) {
        if delegate != nil {
            delegate?.apply(searchViewModel: viewModel)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Identifiers.planesSegueIdentifier {
            if let planesVC = segue.destination.contentViewController as? PlanesTableViewController {
                planesVC.delegate = self
            }
        }
    }

}