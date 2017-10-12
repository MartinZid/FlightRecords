//
//  Plane.swift
//  FlightRecords
//
//  Created by Martin Zid on 12/10/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//

import Foundation
import RealmSwift

final class Plane: Object {
    @objc dynamic var type = ""
    @objc dynamic var model = ""
    @objc dynamic var variant = ""
    @objc dynamic var registrationNumber = ""
    @objc dynamic var motor: Int = 0
}
