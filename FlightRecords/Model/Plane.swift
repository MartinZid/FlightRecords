//
//  Plane.swift
//  FlightRecords
//
//  Created by Martin Zid on 12/10/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//

import Foundation
import RealmSwift

/**
 *Plane* a Realm object class.
 */
final class Plane: Object {
    /// Plane's type
    @objc dynamic var type = ""
    /// Plane's model
    @objc dynamic var model = ""
    /// Plane's variant
    @objc dynamic var variant = ""
    /// Plane's registration number
    @objc dynamic var registrationNumber = ""
    /// Plane's motor. 0 is SE, 1 is ME.
    @objc dynamic var motor: Int = 0
}
