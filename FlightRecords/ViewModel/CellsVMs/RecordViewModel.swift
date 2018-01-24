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
    private let simulator = "Simulator"
    
    init(with record: Record) {
        self.record = record
    }
    
    func getDate() -> String {
        let dateformatter = DateFormatter()
        
        if let date = record.date {
            let dateString = dateformatter.dateToString(from: date)
            return dateString
        }
        return ""
    }
    
    func getDestinations() -> String {
        if record.type == .flight {
            let from = record.from ?? "N/A"
            let to = record.to ?? "N/A"
            return from + "-" + to
        } else {
            return simulator
        }
    }

    func getTime() -> String {
        if let time = record.time {
            return time + " h"
        }
        return ""
    }
    
    func getRegistrationNumber() -> String {
        if record.type == .flight {
            return record.plane?.registrationNumber ?? NSLocalizedString("N/A", comment: "")
        } else {
            return record.simulator ?? NSLocalizedString("N/A", comment: "")
        }
    }
    
}
