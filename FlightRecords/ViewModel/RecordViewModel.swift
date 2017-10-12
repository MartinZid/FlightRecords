//
//  RecordViewModel.swift
//  FlightRecords
//
//  Created by Martin Zid on 12/10/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//

import Foundation

class RecordViewModel {
    
    private let record: Record
    
    init(with record: Record) {
        self.record = record
    }
    
    func getDate() -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd.MM.yyyy"
        
        if let date = record.date {
            let dateString = dateformatter.string(from: date)
            return dateString
        }
        return ""
    }
    
    func getDestinations() -> String {
        return record.from + "-" + record.to
    }
    
    func getTime() -> String {
        return String(record.time) + " h"
    }
    
    func getPlane() -> Plane? {
        return record.plane
    }
    
}
