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

class AddFlightRecordViewModel: RealmViewModel {
    
    private let dateFormatter = DateFormatter()
    
    let date: MutableProperty<Date>
    let timeTKO: MutableProperty<Date>
    let timeLDG: MutableProperty<Date>
    
    let dateString = MutableProperty<String>("")
    let from: MutableProperty<String?>
    let to: MutableProperty<String?>
    let timeTKOString = MutableProperty<String>("")
    let timeLDGString = MutableProperty<String>("")
    let planeString = MutableProperty<String>("")
    let totalTime = MutableProperty<String>("")
    let pic: MutableProperty<String?>
    
    let tkoDay: MutableProperty<Double>
    let tkoDayString = MutableProperty<String>("")
    let tkoNight: MutableProperty<Double>
    let tkoNightString = MutableProperty<String>("")
    
    let ldgDay: MutableProperty<Double>
    let ldgDayString = MutableProperty<String>("")
    let ldgNight: MutableProperty<Double>
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
    
    let note: MutableProperty<String?>
    let plane: MutableProperty<Plane?>
    
    let record: Record?
    
    init(with record: Record?) {
        self.record = record
        
        date = MutableProperty(record?.date ?? Date())
        timeTKO = MutableProperty(record?.timeTKO ?? Date())
        timeLDG = MutableProperty(record?.timeLDG ?? Date())
        
        from = MutableProperty(record?.from ?? nil)
        to = MutableProperty(record?.to ?? nil)
        pic = MutableProperty(record?.pilot ?? nil)
        
        tkoDay = MutableProperty(record?.tkoDay ?? 0)
        tkoNight = MutableProperty(record?.tkoNight ?? 0)
        ldgDay = MutableProperty(record?.ldgDay ?? 0)
        ldgNight = MutableProperty(record?.ldgNight ?? 0)
        
        timeNight = MutableProperty(dateFormatter.createDate(hours: 0, minutes: 0))
        timeIFR = MutableProperty(dateFormatter.createDate(hours: 0, minutes: 0))
        timePIC = MutableProperty(dateFormatter.createDate(hours: 0, minutes: 0))
        timeCO = MutableProperty(dateFormatter.createDate(hours: 0, minutes: 0))
        timeDual = MutableProperty(dateFormatter.createDate(hours: 0, minutes: 0))
        timeInstructor = MutableProperty(dateFormatter.createDate(hours: 0, minutes: 0))
        
        note = MutableProperty(record?.note ?? nil)
        plane = MutableProperty(record?.plane ?? nil)
        
        super.init()
        bindProperties(record: record)
    }
    
    private func bindProperties(record: Record?) {
        dateString <~ date.producer.map(dateFormatter.dateToString)
        timeTKOString <~ timeTKO.producer.map(dateFormatter.timeToString)
        timeLDGString <~ timeLDG.producer.map(dateFormatter.timeToString)
        totalTime <~ SignalProducer.combineLatest(timeTKO.signal, timeLDG.signal)
            .map(countTotalTime).map(dateFormatter.timeToString)
        
        // start with values...
        timeTKO.value = record?.timeTKO ?? Date()
        timeLDG.value = record?.timeLDG ?? Date()
        
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
        
        planeString <~ plane.producer.filterMap(setPlaneLabel)
        //planeString <~ plane.signal.filterMap{ $0?.registrationNumber ?? NSLocalizedString("N/A", comment: "") }
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
    
    private func setPlaneLabel(plane: Plane?) -> String {
        var label = plane?.registrationNumber ?? NSLocalizedString("N/A", comment: "")
        if plane == nil {
            label = ""
        }
        return label
    }
    
    func setPlane(from planeViewModel: PlaneViewModel) {
        plane.value = planeViewModel.getPlane()
    }
    
    func saveRecordToRealm() {
        let record = self.record ?? Record()
        try! realm.write {
            record.type = .flight
            record.date = date.value
            record.from = from.value
            record.timeTKO = timeTKO.value
            record.to = to.value
            record.timeLDG = timeLDG.value
            record.plane = plane.value
            record.time = totalTime.value
            record.pilot = pic.value
            
            record.tkoDay = tkoDay.value
            record.tkoNight = tkoNight.value
            record.ldgDay = ldgDay.value
            record.ldgNight = ldgNight.value
            
            record.timeNight = timeNight.value
            record.timeIFR = timeIFR.value
            record.timePIC = timePIC.value
            record.timeCO = timeCO.value
            record.timeDUAL = timeDual.value
            record.timeInstructor = timeInstructor.value
            
            record.note = note.value
        
            realm.add(record)
        }
    }
}







