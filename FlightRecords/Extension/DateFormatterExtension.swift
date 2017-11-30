//
//  DateFormatterExtension.swift
//  FlightRecords
//
//  Created by Martin Zid on 30/11/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//

import Foundation

extension DateFormatter {
    struct Format{
        static let time = "HH:mm"
        static let date = "dd.MM.yyyy"
    }
    
    func dateToString(from date: Date) -> String {
        dateFormat = Format.date
        return string(from: date)
    }
    
    func timeToString(from date: Date) -> String {
        dateFormat = Format.time
        return string(from: date)
    }
    
    func createDate(hours: Int, minutes: Int) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        let now = Date()
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: now)
        components.hour = hours
        components.minute = minutes
        return calendar.date(from: components)!
    }
    
    func createTime(from time: String) -> Date {
        let timeArray = time.components(separatedBy: ":")
        return createDate(hours: Int(timeArray[0])!, minutes: Int(timeArray[1])!)
    }
    
    func optinalTimeToString(from time: Date?) -> String? {
        if let value = time {
            return timeToString(from: value)
        }
        return nil
    }
    
    func optinalDateToString(from date: Date?) -> String? {
        if let value = date {
            return dateToString(from: value)
        }
        return nil
    }
}
