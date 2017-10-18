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

class AddFlightRecordViewModel {
    var date: MutableProperty<Date>
    
    let dateString = MutableProperty<String>("")
    
    init() {
        date = MutableProperty(Date())
        dateString <~ date.producer.map(dateToString)
    }
    
    private func dateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: date)
    }
}
