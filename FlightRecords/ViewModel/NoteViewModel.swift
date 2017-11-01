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

class NoteViewModel {
    var note: MutableProperty<String>
    let saveAction: Action<(), String, NoError>
    
    init(note: String) {
        self.note = MutableProperty(note)
        saveAction = Action<(), String, NoError>(state: self.note, enabledIf: {$0.characters.count > 0}) { note, _ in
            return SignalProducer<String, NoError> { observer, _ in
                observer.send(value: note)
            }
        }
    }
}
