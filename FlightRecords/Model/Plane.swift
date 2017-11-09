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
    @objc dynamic var type: String? = nil
    /// Plane's model
    @objc dynamic var model: String? = nil
    /// Plane's variant
    @objc dynamic var variant: String? = nil
    /// Plane's registration number
    @objc dynamic var registrationNumber: String? = nil
    /// Plane's motor. 0 is SE, 1 is ME.
    @objc dynamic var engine: Engine = .single
    
    @objc enum Engine: Int {
        case single = 0
        case multi = 1
    }
}
