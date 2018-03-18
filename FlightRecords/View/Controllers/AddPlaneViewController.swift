//
//  AddPlaneViewController.swift
//  FlightRecords
//
//  Created by Martin Zid on 09/11/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class AddPlaneViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var modelTextField: UITextField!
    @IBOutlet weak var variantTextField: UITextField!
    @IBOutlet weak var registrationNumberTextField: UITextField!
    @IBOutlet weak var engineTextField: UITextField!
    
    private let picker = UIPickerView()
    
    var viewModel: AddPlaneViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        bindViewModel()
        setEndEditingOnTap()
    }
    
    private func bindViewModel() {
        self.title = viewModel.title
        
        typeTextField.text = viewModel.type.value
        modelTextField.text = viewModel.model.value
        variantTextField.text = viewModel.variant.value
        registrationNumberTextField.text = viewModel.registrationNumber.value
        engineTextField.text = viewModel.engineString.value
        
        viewModel.type <~ typeTextField.reactive.continuousTextValues.filterMap{ $0 }
        viewModel.model <~ modelTextField.reactive.continuousTextValues.filterMap{ $0 }
        viewModel.variant <~ variantTextField.reactive.continuousTextValues.filterMap{ $0 }
        viewModel.registrationNumber <~ registrationNumberTextField.reactive.continuousTextValues.filterMap{ $0 }
        viewModel.engineString <~ engineTextField.reactive.continuousTextValues.filterMap{ $0 }
    }

    @IBAction func engineFieldEditing(_ sender: UITextField) {
        sender.inputView = picker
    }
    
    @IBAction func save(_ sender: Any) {
        viewModel.savePlaneToRealm()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: typeTextField.becomeFirstResponder()
        case 1: modelTextField.becomeFirstResponder()
        case 2: variantTextField.becomeFirstResponder()
        case 3: registrationNumberTextField.becomeFirstResponder()
        case 4: engineTextField.becomeFirstResponder()
        default: break
        }
    }
    
    // MARK: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.getEnginesCount()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.getEngine(for: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        engineTextField.text = viewModel.getEngine(for: row)
        viewModel.engineString.value = viewModel.getEngine(for: row)
    }
    
}
