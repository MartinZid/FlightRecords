//
//  AddMedicalCertificateViewController.swift
//  FlightRecords
//
//  Created by Martin Zid on 21/12/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class AddMedicalCertificateViewController: RecordTableViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var publicationDateTextField: UITextField!
    @IBOutlet weak var expirationDateTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    var viewModel: AddMedicalCertificateViewModel!
    
    private let picker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        if viewModel == nil {
            viewModel = AddMedicalCertificateViewModel(with: nil)
        }
        setEndEditingOnTap()
        bindViewModel()
    }
    
    private func bindViewModel() {
        self.title = viewModel.title
        
        typeTextField.text = viewModel.typeString.value
        nameTextField.text = viewModel.name.value
        publicationDateTextField.text = viewModel.publicationString.value
        expirationDateTextField.text = viewModel.expirationString.value
        descriptionTextField.text = viewModel.description.value
        
        viewModel.typeString <~ typeTextField.reactive.continuousTextValues.filterMap{ $0 }
        viewModel.name <~ nameTextField.reactive.continuousTextValues.filterMap{ $0 }
        viewModel.description <~ descriptionTextField.reactive.continuousTextValues.filterMap{ $0 }
        
        expirationDateTextField.reactive.text <~ viewModel.expirationString
        publicationDateTextField.reactive.text <~ viewModel.publicationString
    }
    
    @IBAction func typeFieldEditing(_ sender: UITextField) {
        sender.inputView = picker
    }
    
    @IBAction func publicationTextFieldEditing(_ sender: UITextField) {
        _ = handleDatePicker(for: sender, with: .date, and: viewModel.publication, default: Date())
    }
    
    @IBAction func expirationTextFieldEditing(_ sender: UITextField) {
        _ = handleDatePicker(for: sender, with: .date, and: viewModel.expiration, default: Date())
    }
    
    @IBAction func save(_ sender: Any) {
        viewModel.saveCertificateToRealm()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: typeTextField.becomeFirstResponder()
        case 1: nameTextField.becomeFirstResponder()
        case 2: publicationDateTextField.becomeFirstResponder()
        case 3: expirationDateTextField.becomeFirstResponder()
        case 4: descriptionTextField.becomeFirstResponder()
        default: break
        }
    }
    
    // MARK: - UIPickerViewDataSource
        
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.getTypesCount()
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.getType(for: row)
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        typeTextField.text = viewModel.getType(for: row)
        viewModel.typeString.value = viewModel.getType(for: row)
    }
}
