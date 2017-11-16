//
//  Record.swift
//  FlightRecords
//
//  Created by Martin Zid on 12/10/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//

import Foundation
import RealmSwift


final class Record: Object {
    @objc dynamic var type: RecordType = .flight
    
    @objc dynamic var date: Date?
    @objc dynamic var from: String? = nil
    @objc dynamic var timeTKO: Date?
    @objc dynamic var to: String? = nil
    @objc dynamic var timeLDG: Date?
    @objc dynamic var plane: Plane?
    @objc dynamic var time: String? = nil
    @objc dynamic var pilot: String? = nil
    
    @objc dynamic var tkoDay: Double = 0
    @objc dynamic var tkoNight: Double = 0
    @objc dynamic var ldgDay: Double = 0
    @objc dynamic var ldgNight: Double = 0
    
    @objc dynamic var timeNight: Date?
    @objc dynamic var timeIFR: Date?
    @objc dynamic var timePIC: Date?
    @objc dynamic var timeCO: Date?
    @objc dynamic var timeDUAL: Date?
    @objc dynamic var timeInstructor: Date?
    
    @objc dynamic var note: String?
    
    @objc dynamic var simulator: String?
    
    @objc enum RecordType: Int {
        case flight
        case simulator
    }
}
