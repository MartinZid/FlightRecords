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
    @objc dynamic var date: Date?
    @objc dynamic var from = ""
    @objc dynamic var to = ""
    @objc dynamic var time: Int = 0
    @objc dynamic var plane: Plane?
}
