//
//  File.swift
//  FlightRecords
//
//  Created by Martin Zid on 16/11/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//

import Foundation
import ReactiveSwift

class AddSimulatorRecordViewModel: RealmViewModel {
    
    private let dateFormatter = DateFormatter()
    
    let date: MutableProperty<Date>
    let time: MutableProperty<Date>
    let type: MutableProperty<String?>
    let note: MutableProperty<String?>
    
    let dateString = MutableProperty<String>("")
    let timeString = MutableProperty<String>("")
    
    init(with record: Record?) {
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
    
    func saveRecordToRealm() {
        let record = Record()
        record.type = .simulator
        record.date = date.value
        record.time = timeString.value
        record.simulator = type.value
        record.note = note.value
        
        try! realm.write {
            realm.add(record)
        }
    }
    
}
