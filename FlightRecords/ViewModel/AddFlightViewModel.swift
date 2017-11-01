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
    
    private let dateFormatter = DateFormatter()
    
    let date = MutableProperty(Date())
    let timeTKO = MutableProperty(Date())
    let timeLDG = MutableProperty(Date())
    
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
    
    let timeNight: MutableProperty<Date>
    let timeNightString = MutableProperty<String>("")
    let timeIFR: MutableProperty<Date>
    let timeIFRString = MutableProperty<String>("")
    let timePIC: MutableProperty<Date>
    let timePICString = MutableProperty<String>("")
    let timeCO: MutableProperty<Date>
    let timeCOString = MutableProperty<String>("")
    let timeDual: MutableProperty<Date>
    let timeDualString = MutableProperty<String>("")
    let timeInstructor: MutableProperty<Date>
    let timeInstructorString = MutableProperty<String>("")
    
    let note = MutableProperty<String>("")
    
    init() {
        timeNight = MutableProperty(dateFormatter.createDate(hours: 0, minutes: 0))
        timeIFR = MutableProperty(dateFormatter.createDate(hours: 0, minutes: 0))
        timePIC = MutableProperty(dateFormatter.createDate(hours: 0, minutes: 0))
        timeCO = MutableProperty(dateFormatter.createDate(hours: 0, minutes: 0))
        timeDual = MutableProperty(dateFormatter.createDate(hours: 0, minutes: 0))
        timeInstructor = MutableProperty(dateFormatter.createDate(hours: 0, minutes: 0))
        
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
        
        timeNightString <~ timeNight.producer.map(dateFormatter.timeToString)
        timeIFRString <~ timeIFR.producer.map(dateFormatter.timeToString)
        timePICString <~ timePIC.producer.map(dateFormatter.timeToString)
        timeCOString <~ timeCO.producer.map(dateFormatter.timeToString)
        timeDualString <~ timeDual.producer.map(dateFormatter.timeToString)
        timeInstructorString <~ timeInstructor.producer.map(dateFormatter.timeToString)
    }

    private func countTotalTime(timeTKO: Date, timeLDG: Date) -> Date {
        var interval: Int
        var dateTmp: Date
        
        if(timeTKO.compare(timeLDG).rawValue == 1) { // the flight took place in two days
            dateTmp = dateFormatter.createDate(hours: 0, minutes: 0)
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
