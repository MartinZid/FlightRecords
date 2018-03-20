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
 ViewModel for creating/editing a note.
 */
class NoteViewModel {
    
    var note: MutableProperty<String?>
    let saveAction: Action<(), String, NoError>
    
    // MARK: - Initialization
    
    init(note: String?) {
        self.note = MutableProperty(note)
        saveAction = Action<(), String, NoError>(
            state: self.note, enabledIf: {
            if let note = $0 {
                return note.count > 0
            }
            return false
        }) { note, _ in
            return SignalProducer<String, NoError> { observer, _ in
                observer.send(value: note!)
            }
        }
    }
}
