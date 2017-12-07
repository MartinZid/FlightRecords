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
    
    private func getDateComponents() -> DateComponents {
        let calendar = Calendar(identifier: .gregorian)
        let now = Date()
        return calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: now)
    }
    
    func createDate(hours: Int, minutes: Int) -> Date {
        var components = getDateComponents()
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
    
    func getDateYearAgo(from: Date) -> Date {
        var components = getDateComponents()
        components.hour = 0
        components.minute = 0
        components.second = 0
        components.year = components.year! - 1
        return calendar.date(from: components)!
    }
    
    func getThisYearStartingDate() -> Date {
        var components = getDateComponents()
        components.month = 1
        components.day = 1
        components.hour = 0
        components.minute = 0
        components.second = 0
        return calendar.date(from: components)!
    }
}




