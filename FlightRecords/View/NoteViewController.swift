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

/**
 To NoteViewControllerDelegate is delegated save action of the note.
 */
protocol NoteViewControllerDelegate {
    func save(note: String)
}
/**
 NoteViewController is used for creating/editing flight note.
 */
class NoteViewController: UIViewController {

    /// UIBarButton which saves user's note
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    /// UITextField contains the note
    @IBOutlet weak var noteField: UITextField!
    
    /// delegate who is saves the note
    var delegate: NoteViewControllerDelegate? = nil
    /// note variable
    var note: String!

    /// NoteViewModel handles save action and note value
    private var viewModel: NoteViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = NoteViewModel(note: note)
        bindViewModel()
        noteField.becomeFirstResponder()
    }
    
    /**
     This function binds viewModel to View.
     */
    private func bindViewModel() {
        noteField.text = viewModel.note.value
        viewModel.note <~ noteField.reactive.continuousTextValues.filterMap{$0}
        saveBtn.reactive.pressed = CocoaAction(viewModel.saveAction)
        viewModel.saveAction.values.observeValues(save)
    }
    
    /**
     observeValues action function. Delegates the save to delegate (if one is set) and closes the modal.
     - Parameter note: note String.
     */
    private func save(note: String) {
        if delegate != nil {
            delegate?.save(note: note)
        }
        self.dismiss(animated: true, completion: nil)
    }

    /**
     Cancel function closes the modal.
    */
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
