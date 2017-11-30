//
//  PersonalInformationsViewController.swift
//  FlightRecords
//
//  Created by Martin Zid on 30/11/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift

class PersonalInformationsViewController: RecordTableViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var birthDayTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    
    private let viewModel = PersonalInformationsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setEndEditingOnTap()
    }
    
    private func bindViewModel() {
        viewModel.dataSetSignal.observeValues { [weak self] in
            self?.nameTextField.text = self?.viewModel.name.value
            self?.surnameTextField.text = self?.viewModel.surname.value
            self?.birthDayTextField.text = self?.viewModel.birthDayString.value
            self?.addressTextField.text = self?.viewModel.address.value
        }
        viewModel.name <~ nameTextField.reactive.continuousTextValues.filterMap{ $0 }
        viewModel.surname <~ surnameTextField.reactive.continuousTextValues.filterMap{ $0 }
        birthDayTextField.reactive.text <~ viewModel.birthDayString
        viewModel.address <~ addressTextField.reactive.continuousTextValues.filterMap{ $0 }
    }
    
    @IBAction func save(_ sender: Any) {
        viewModel.saveInfo()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func birthDayTextFieldEditing(_ sender: UITextField) {
        if sender.inputView == nil {
            let datePicker = assingUIDatePicker(to: sender, with: .date)
            bind(datepicker: datePicker, to: viewModel.birthDay)
            if let date = viewModel.birthDay.value {
                datePicker.date = date
            }
        }
    }
    
}
