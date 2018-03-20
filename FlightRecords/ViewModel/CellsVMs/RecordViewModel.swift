//
//  RecordViewModel.swift
//  FlightRecords
//
//  Created by Martin Zid on 12/10/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//

import Foundation

/**
 RecordViewModel prepares data for RecordCell.
 */
class RecordViewModel {
    
    private let record: Record
    private let simulator = "Simulator"
    
    // MARK: - Initialization
    
    init(with record: Record) {
        self.record = record
    }
    
    // MARK: - API
    
    func getDate() -> String {
        let dateformatter = DateFormatter()
        
        if let date = record.date {
            let dateString = dateformatter.dateToString(from: date)
            return dateString
        }
        return ""
    }
    
    /**
     This function takes Record's destinations (from and to) and combines them.
     - Returns: String in format: from-to.
     */
    func getDestinations() -> String {
        if record.type == .flight {
            let from = record.from ?? "N/A"
            let to = record.to ?? "N/A"
            return from + "-" + to
        } else {
            return simulator
        }
    }

    /**
     getTime function converts Record's time to String and appends "h" (hours) to the end.
     - Returns: Time String eg.: 8 h.
     */
    func getTime() -> String {
        if let time = record.time {
            return time + " h"
        }
        return ""
    }
    
    /**
     This function returns plane's registration number or simulator type. If it is not set, return localized N/A.
     */
    func getRegistrationNumber() -> String {
        if record.type == .flight {
            return record.plane?.registrationNumber ?? NSLocalizedString("N/A", comment: "")
        } else {
            return record.simulator ?? NSLocalizedString("N/A", comment: "")
        }
    }
    
}
