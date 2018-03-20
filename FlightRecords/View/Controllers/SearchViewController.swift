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

/**
 A form like UITableViewController for the search configuration specification.
 */
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
    
    // MARK: - Controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setEndEditingOnTap()
    }
    
    // MARK: - Bindings
    
    private func bindViewModel() {
        setDefaultValues()
        
        viewModel.searchText <~ searchTextField.reactive.continuousTextValues.filterMap{ $0 }
        viewModel.flightsSwitch <~ flightsSwitch.reactive.isOnValues
        viewModel.fstdSwitch <~ fstdSwitch.reactive.isOnValues
        viewModel.planeType <~ planeTypeTextField.reactive.continuousTextValues.filterMap{ $0 }
        planeLabel.reactive.text <~ viewModel.planeLabel
        
        fromDateTextField.reactive.text <~ viewModel.fromDateString
        toDateTextField.reactive.text <~ viewModel.toDateString
        
        // animate correctly hiding and appearing of text fields
        viewModel.flightsSwitch.signal.observeValues { [weak self] value in
            self?.tableView.beginUpdates()
            self?.tableView.endUpdates()
        }
    }
    
    // MARK: - Actions
    
    @IBAction func fromTextFieldEditing(_ sender: UITextField) {
        _ = handleDatePicker(for: sender, with: .date, and: viewModel.fromDate, default: Date())
    }
    
    @IBAction func toTextFieldEditing(_ sender: UITextField) {
        let datePicker = handleDatePicker(for: sender, with: .date, and: viewModel.toDate, default: viewModel.getDefaultToDateValue())
        setMinDateOnSignal(to: datePicker)
    }
    
    /**
     This action displays an alert and if user confirms his action, it sets all input fields to their default values.
     */
    @IBAction func clearSearchParameters(_ sender: Any) {
        confirmClearAction { [weak self] _ in
            self?.viewModel.clearSearchParameters()
            self?.setDefaultValues()
            self?.resetDateInputTextFields()
        }
    }
    
    @IBAction func done(_ sender: Any) {
        if delegate != nil {
            delegate?.apply(searchViewModel: viewModel)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helpers
    
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
    
    private func setDefaultValues() {
        searchTextField.text = viewModel.searchText.value
        flightsSwitch.isOn = viewModel.flightsSwitch.value
        fstdSwitch.isOn = viewModel.fstdSwitch.value
        planeTypeTextField.text = viewModel.planeType.value
    }
    
    private func resetDateInputTextFields() {
        fromDateTextField.inputView = nil
        toDateTextField.inputView = nil
    }
    
    /**
     Displays alert confirming clear action.
     - parameters:
     - action: action which will be called if user confirms
     */
    private func confirmClearAction(_ action: @escaping ((UIAlertAction) -> Void)) {
        let alert = UIAlertController(
            title: NSLocalizedString("Clear confirm", comment: ""),
            message: NSLocalizedString("Clear search confirm message", comment: ""),
            preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Clear", comment: ""),
                                      style: UIAlertActionStyle.default, handler: action))
        alert.addAction(UIAlertAction(title: NSLocalizedString("No", comment: ""),
                                      style: UIAlertActionStyle.cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - PlanesTableViewControllerDelegate
    
    func userDidSelect(planeViewModel: PlaneViewModel) {
        viewModel.setPlane(from: planeViewModel)
    }
    
    // MARK: - UITableView data source
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row == 4
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.clearPlane()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if !viewModel.flightsSwitch.value { // hide unnecessary input fields
            if indexPath.row == 3 || indexPath.row == 4 {
                return 0.0
            }
        }
        return 44.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0: searchTextField.becomeFirstResponder()
            case 3: planeTypeTextField.becomeFirstResponder()
            default: break
            }
        } else if indexPath.section == 1 {
            switch indexPath.row {
            case 0: fromDateTextField.becomeFirstResponder()
            case 1: toDateTextField.becomeFirstResponder()
            default: break
            }
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Identifiers.planesSegueIdentifier {
            if let planesVC = segue.destination.contentViewController as? PlanesTableViewController {
                planesVC.delegate = self
            }
        }
    }

}
