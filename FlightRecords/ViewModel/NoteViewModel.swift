//
//  NoteViewModel.swift
//  FlightRecords
//
//  Created by Martin Zid on 01/11/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

/**
 NoteViewModel is viewModel for NoteViewController.
 */
class NoteViewModel {
    /// Note is bind to textField and contains note String.
    var note: MutableProperty<String>
    /// Action which is invoked when Save button is clicked. Save button is enabled only if note is not empty.
    let saveAction: Action<(), String, NoError>
    
    /**
    Creates new NoteViewModel object with given note. Also initializes save action.
    - Parameter note: Note String.
     */
    init(note: String) {
        self.note = MutableProperty(note)
        saveAction = Action<(), String, NoError>(state: self.note, enabledIf: {$0.count > 0}) { note, _ in
            return SignalProducer<String, NoError> { observer, _ in
                observer.send(value: note)
            }
        }
    }
}
