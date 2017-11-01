//
//  NoteViewController.swift
//  FlightRecords
//
//  Created by Martin Zid on 01/11/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import Result

protocol NoteViewControllerDelegate {
    func save(note: String)
}

class NoteViewController: UIViewController {

    @IBOutlet weak var saveBtn: UIBarButtonItem!
    @IBOutlet weak var noteField: UITextField!
    
    var delegate: NoteViewControllerDelegate? = nil
    var note: String!

    private var viewModel: NoteViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = NoteViewModel(note: note)
        bindViewModel()
        noteField.becomeFirstResponder()
    }
    
    func bindViewModel() {
        noteField.text = viewModel.note.value
        viewModel.note <~ noteField.reactive.continuousTextValues.filterMap{$0}
        saveBtn.reactive.pressed = CocoaAction(viewModel.saveAction)
        viewModel.saveAction.values.observeValues(save)
    }
    
    private func save(note: String) {
        if delegate != nil {
            delegate?.save(note: note)
        }
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
