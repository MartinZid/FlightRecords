//
//  DateConvertor.swift
//  FlightRecords
//
//  Created by Martin Zid on 19/10/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//

import Foundation

class DateConvertor {
    private let dateFormatter = DateFormatter()
    private struct Format{
        static let time = "HH:mm"
        static let date = "dd.MM.yyyy"
    }
    
    func dateToString(date: Date) -> String {
        dateFormatter.dateFormat = Format.date
        return dateFormatter.string(from: date)
    }
    
    func timeToString(date: Date) -> String {
        dateFormatter.dateFormat = Format.time
        return dateFormatter.string(from: date)
    }
}
