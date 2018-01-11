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
    
    let timeNight: MutableProperty<Date?>
    let timeNightString = MutableProperty<String?>(nil)
    let timeIFR: MutableProperty<Date?>
    let timeIFRString = MutableProperty<String?>(nil)
    let timePIC: MutableProperty<Date?>
    let timePICString = MutableProperty<String?>(nil)
    let timeCO: MutableProperty<Date?>
    let timeCOString = MutableProperty<String?>(nil)
    let timeDual: MutableProperty<Date?>
    let timeDualString = MutableProperty<String?>(nil)
    let timeInstructor: MutableProperty<Date?>
    let timeInstructorString = MutableProperty<String?>(nil)
    
    let note: MutableProperty<String?>
    let plane: MutableProperty<Plane?>
    
    let record: Record?
    
    let title: String
    
    init(with record: Record?) {
        self.record = record
        title = (record == nil ? NSLocalizedString("Add new flight record", comment: "") : NSLocalizedString("Edit flight record", comment: ""))
        
        date = MutableProperty(record?.date ?? Date())
        let tmpDate = Date()
        timeTKO = MutableProperty(record?.timeTKO ?? tmpDate)
        timeLDG = MutableProperty(record?.timeLDG ?? tmpDate)
        
        from = MutableProperty(record?.from ?? nil)
        to = MutableProperty(record?.to ?? nil)
        pic = MutableProperty(record?.pilot ?? nil)
        
        tkoDay = MutableProperty(record?.tkoDay ?? 0)
        tkoNight = MutableProperty(record?.tkoNight ?? 0)
        ldgDay = MutableProperty(record?.ldgDay ?? 0)
        ldgNight = MutableProperty(record?.ldgNight ?? 0)
        
        timeNight = MutableProperty(record?.timeNight)
        timeIFR = MutableProperty(record?.timeIFR)
        timePIC = MutableProperty(record?.timePIC)
        timeCO = MutableProperty(record?.timeCO)
        timeDual = MutableProperty(record?.timeDUAL)
        timeInstructor = MutableProperty(record?.timeInstructor)
        
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
        
        timeNightString <~ timeNight.producer.map(dateFormatter.optinalTimeToString)
        timeIFRString <~ timeIFR.producer.map(dateFormatter.optinalTimeToString)
        timePICString <~ timePIC.producer.map(dateFormatter.optinalTimeToString)
        timeCOString <~ timeCO.producer.map(dateFormatter.optinalTimeToString)
        timeDualString <~ timeDual.producer.map(dateFormatter.optinalTimeToString)
        timeInstructorString <~ timeInstructor.producer.map(dateFormatter.optinalTimeToString)
        
        planeString <~ plane.producer.filterMap(setPlaneLabel)
        totalTime.signal.observeValues(checkAllTimeProperties)
    }

    private func countTotalTime(timeTKO: Date, timeLDG: Date) -> Date {
        var interval: Int
        let componentsTKO = dateFormatter.getDateComponents(from: timeTKO)
        let componentsLDG = dateFormatter.getDateComponents(from: timeLDG)
        
        if(timeTKO.compare(timeLDG) == .orderedDescending) { // the flight took place in two days
            // time from TKO to midnight
            interval = (23 - componentsTKO.hour!) * 60 //we need to consider minutes (if 0 in timeTKO we add 60 to interval)
            interval += 60 - componentsTKO.minute!
            
            interval += componentsLDG.hour! * 60
            interval += componentsLDG.minute!
            
        } else { // simple one day flight
            interval = (componentsLDG.hour! - componentsTKO.hour!) * 60
            interval += componentsLDG.minute! - componentsTKO.minute!
        }
        
        let hours: Int = (interval/60) % 24
        let minutes: Int = interval % 60
        
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
    
    private func checkAllTimeProperties(for string: String) {
        let date = dateFormatter.createTime(from: string)
        if let value = timeNight.value, value.timeIntervalSince(date) > 0 {
            timeNight.value = date
        }
        if let value = timeIFR.value, value.timeIntervalSince(date) > 0 {
            timeIFR.value = date
        }
        if let value = timePIC.value, value.timeIntervalSince(date) > 0 {
            timePIC.value = date
        }
        if let value = timeCO.value, value.timeIntervalSince(date) > 0 {
            timeCO.value = date
        }
        if let value = timeDual.value, value.timeIntervalSince(date) > 0 {
            timeDual.value = date
        }
        if let value = timeInstructor.value, value.timeIntervalSince(date) > 0 {
            timeInstructor.value = date
        }
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







