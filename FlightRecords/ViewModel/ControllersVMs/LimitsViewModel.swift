//
//  LimitsViewModel.swift
//  FlightRecords
//
//  Created by Martin Zid on 07/12/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveSwift
import RealmSwift

class LimitsViewModel: RealmViewModel {
    
    private var records: Results<Record>?
    
    let inDays = MutableProperty<Float>(0.0)
    let inDaysString = MutableProperty<String>("0:0")
    let inDaysLabel = MutableProperty<String>("?/100")
    
    let inYear = MutableProperty<Float>(0.0)
    let inYearString = MutableProperty<String>("0:0")
    let inYearLabel = MutableProperty<String>("?/900")
    
    let inMonths = MutableProperty<Float>(0.0)
    let inMonthsString = MutableProperty<String>("0:0")
    let inMonthsLabel = MutableProperty<String>("?/1000")
    
    private let day: Double = 60 * 60 * 24
    private let dateFormatter = DateFormatter()
    
    override init() {
        super.init()
        inDays <~ inDaysString.producer.map(stringTimeToFloat)
        inDaysLabel <~ inDaysString.producer.map{ $0 + "/100" }
        
        inYear <~ inYearString.producer.map(stringTimeToFloat)
        inYearLabel <~ inYearString.producer.map{ $0 + "/900"}
        
        inMonths <~ inMonthsString.producer.map(stringTimeToFloat)
        inMonthsLabel <~ inMonthsString.producer.map{ $0 + "/1000"}
    }
    
    private func stringTimeToFloat(time: String) -> Float {
        let timeArray = time.components(separatedBy: ":")
        let time = Float(timeArray[0])! + Float(Float(timeArray[1])!/60.0)
        return time
    }
    
    private func updateData() {
        records = realm.objects(Record.self)
        countHoursForLimits()
    }
    
    override func realmInitCompleted() {
        updateData()
    }
    
    override func notificationHandler(notification: Realm.Notification, realm: Realm) {
        updateData()
    }
    
    private func countHoursForLimits() {
        inDaysString.value = countFlightTimeInLastDays()
        inYearString.value = countFlightTimeInLastYear()
        inMonthsString.value = countFlightTimeInLastMonths()
    }
    
    private func countTimeInInterval(starting from: Date, ending to: Date) -> String {
        var hours = 0
        var minutes = 0
        var tmpRecords = records
        
        tmpRecords = tmpRecords?.filter("date >= %@", from)
        tmpRecords = tmpRecords?.filter("date <= %@", to)
        if let records = tmpRecords {
            for record in records {
                if let time = record.time {
                    let timeArray = time.components(separatedBy: ":")
                    hours += Int(timeArray[0])!
                    minutes += Int(timeArray[1])!
                }
            }
        }
        hours += minutes/60
        minutes = minutes % 60
        return String(hours) + ":" + ((minutes != 0) ? String(minutes) : "00")
    }
    
    private func countFlightTimeInLastDays() -> String {
        // fromDate should be initialized with time 00:00, for correct calculation
        let fromDate = dateFormatter.createDate(hours: 0, minutes: 0).addingTimeInterval(-(28 * day))
        let toDate = Date()
        return countTimeInInterval(starting: fromDate, ending: toDate)
    }
    
    private func countFlightTimeInLastYear() -> String {
        let fromDate = dateFormatter.getThisYearStartingDate()
        let toDate = Date()
        return countTimeInInterval(starting: fromDate, ending: toDate)
    }
    
    private func countFlightTimeInLastMonths() -> String {
        let fromDate = dateFormatter.getDateYearAgo(from: Date())
        let toDate = Date()
        return countTimeInInterval(starting: fromDate, ending: toDate)
    }
    
}
