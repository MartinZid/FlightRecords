//
//  RecordViewModel.swift
//  FlightRecords
//
//  Created by Martin Zid on 12/10/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//

import Foundation

/**
 RecordViewModel is RecordCell's viewModel. It prepares the data to be show in each cell.
 */
class RecordViewModel {
    
    /// Record model object
    private let record: Record
    private let simulator = "Simulator"
    
    /**
     Init function initializes RecordViewModel with given Record.
     - Parameter record: Record object.
     */
    init(with record: Record) {
        self.record = record
    }
    
    /**
     This function converts Record's date to String.
     Format dd.MM.yyyy.
     - Returns: dd.MM.yyyy String of Record's date, if the date is set. Or empty string if is not set.
     */
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
     - Returns: Record's plane.
     */
    func getRegistrationNumber() -> String {
        if record.type == .flight {
            return record.plane?.registrationNumber ?? NSLocalizedString("N/A", comment: "")
        } else {
            return record.simulator ?? NSLocalizedString("N/A", comment: "")
        }
    }
    
}
