//
//  Record.swift
//  FlightRecords
//
//  Created by Martin Zid on 12/10/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//

import Foundation
import RealmSwift

/**
 *Record* a Realm object class.
 */
final class Record: Object {
    /// Date of *Record*'s flight.
    @objc dynamic var date: Date?
    /// Place of *Record*'s flight take off.
    @objc dynamic var from = ""
    /// Place of *Record*'s flight landing.
    @objc dynamic var to = ""
    /// Total time of *Record*'s flight.
    @objc dynamic var time: Int = 0
    /// Plane which was used in *Record*'s flight.
    @objc dynamic var plane: Plane?
}
