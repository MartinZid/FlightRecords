//
//  File.swift
//  FlightRecords
//
//  Created by Martin Zid on 16/11/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//

import Foundation
import ReactiveSwift

/**
 Add/update simulator record ViewModel.
 */
class AddSimulatorRecordViewModel: RealmViewModel {
    
    private let dateFormatter = DateFormatter()
    
    let date: MutableProperty<Date>
    let time: MutableProperty<Date>
    let type: MutableProperty<String?>
    let note: MutableProperty<String?>
    
    let dateString = MutableProperty<String>("")
    let timeString = MutableProperty<String>("")
    
    let record: Record?
    let title: String
    
    // MARK: - Initialization
    
    init(with record: Record?) {
        self.record = record
        title = (record == nil ? NSLocalizedString("Add new simulator record", comment: "") : NSLocalizedString("Edit simulator record", comment: ""))
        
        date = MutableProperty(record?.date ?? Date())
        var timeDate: Date!
        if let time = record?.time {
            let timeArray = time.components(separatedBy: ":")
            timeDate = dateFormatter.createDate(hours: Int(timeArray[0])!, minutes: Int(timeArray[1])!)
        } else {
            timeDate = dateFormatter.createDate(hours: 0, minutes: 0)
        }
        time = MutableProperty(timeDate)
        type = MutableProperty(record?.simulator ?? nil)
        note = MutableProperty(record?.note ?? nil)
        
        dateString <~ date.producer.map(dateFormatter.dateToString)
        timeString <~ time.producer.map(dateFormatter.timeToString)
    }
    
    // MARK: - API
    
    func saveRecordToRealm() {
        let record = self.record ?? Record()
        try! realm.write {
            record.type = .simulator
            record.date = date.value
            record.time = timeString.value
            record.simulator = type.value
            record.note = note.value
        
            realm.add(record)
        }
    }
    
}
