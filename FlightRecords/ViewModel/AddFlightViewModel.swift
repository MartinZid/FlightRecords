//
//  AddFlightViewModel.swift
//  FlightRecords
//
//  Created by Martin Zid on 18/10/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

class AddFlightRecordViewModel {
    let date: MutableProperty<Date>
    let timeTKO: MutableProperty<Date>
    let timeLDG: MutableProperty<Date>
    
    let dateString = MutableProperty<String>("")
    let from = MutableProperty<String>("")
    let to = MutableProperty<String>("")
    let timeTKOString = MutableProperty<String>("")
    let timeLDGString = MutableProperty<String>("")
    let plane = MutableProperty<String>("")
    let totalTime = MutableProperty<String>("")
    let pic = MutableProperty<String>("")
    
    private let dateFormatter = DateFormatter()
    
    init() {
        date = MutableProperty(Date())
        timeTKO = MutableProperty(Date())
        timeLDG = MutableProperty(Date())
        
        dateString <~ date.producer.map(dateFormatter.dateToString)
        timeTKOString <~ timeTKO.producer.map(dateFormatter.timeToString)
        timeLDGString <~ timeLDG.producer.map(dateFormatter.timeToString)
        totalTime <~ Signal.combineLatest(timeTKO.signal, timeLDG.signal).map(countTotalTime).map(dateFormatter.timeToString)
    }

    private func countTotalTime(timeTKO: Date, timeLDG: Date) -> Date {
        var interval: Int
        dateFormatter.dateFormat = "HH:mm"
        var dateTmp: Date
        
        if(timeTKO.compare(timeLDG).rawValue == 1) {
            dateTmp = dateFormatter.date(from: "00:00")!
            interval = Int(timeLDG.timeIntervalSince(dateTmp))
            
            dateTmp.addTimeInterval(TimeInterval(3600*24))
            interval += Int(dateTmp.timeIntervalSince(timeTKO))
        } else {
            interval = Int(timeLDG.timeIntervalSince(timeTKO))
        }
        
        let hours: Int = interval/3600
        let minutes: Int = (interval % 3600) / 60
        let date = dateFormatter.date(from: "\(String(hours)):\(String(minutes))")
        return date!
    }
}
