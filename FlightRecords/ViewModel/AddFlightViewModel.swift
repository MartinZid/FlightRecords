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
    
    let tkoDay = MutableProperty<Double>(0)
    let tkoDayString = MutableProperty<String>("")
    let tkoNight = MutableProperty<Double>(0)
    let tkoNightString = MutableProperty<String>("")
    
    let ldgDay = MutableProperty<Double>(0)
    let ldgDayString = MutableProperty<String>("")
    let ldgNight = MutableProperty<Double>(0)
    let ldgNightString = MutableProperty<String>("")
    
    private let dateFormatter = DateFormatter()
    
    init() {
        date = MutableProperty(Date())
        timeTKO = MutableProperty(Date())
        timeLDG = MutableProperty(Date())
        
        dateString <~ date.producer.map(dateFormatter.dateToString)
        timeTKOString <~ timeTKO.producer.map(dateFormatter.timeToString)
        timeLDGString <~ timeLDG.producer.map(dateFormatter.timeToString)
        totalTime <~ SignalProducer.combineLatest(timeTKO.signal, timeLDG.signal)
            .map(countTotalTime).map(dateFormatter.timeToString)
        
        // start with values...
        timeTKO.value = Date()
        timeLDG.value = Date()
        
        tkoDayString <~ tkoDay.producer.map(doubleToString)
        tkoNightString <~ tkoNight.producer.map(doubleToString)
        ldgDayString <~ ldgDay.producer.map(doubleToString)
        ldgNightString <~ ldgNight.producer.map(doubleToString)
    }

    private func countTotalTime(timeTKO: Date, timeLDG: Date) -> Date {
        var interval: Int
        dateFormatter.dateFormat = "HH:mm"
        var dateTmp: Date
        
        if(timeTKO.compare(timeLDG).rawValue == 1) { // the flight took place in two days
            dateTmp = dateFormatter.date(from: "00:00")!
            interval = Int(timeLDG.timeIntervalSince(dateTmp))
            
            dateTmp.addTimeInterval(TimeInterval(3600*24))
            interval += Int(dateTmp.timeIntervalSince(timeTKO))
        } else { // simple one day flight
            interval = Int(timeLDG.timeIntervalSince(timeTKO))
        }
        
        let hours: Int = (interval/3600) % 24
        let minutes: Int = (interval % 3600) / 60
        let date = dateFormatter.date(from: "\(String(hours)):\(String(minutes))")
        return date!
    }
    
    private func doubleToString(value: Double) -> String {
        return "\(Int(value))"
    }
}
