//
//  Extension.swift
//  FlightRecords
//
//  Created by Martin Zid on 19/10/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//

import Foundation

extension DateFormatter {
    private struct Format{
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
}
