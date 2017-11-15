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
    @objc dynamic var type: String? = nil
    @objc dynamic var model: String? = nil
    @objc dynamic var variant: String? = nil
    @objc dynamic var registrationNumber: String? = nil
    @objc dynamic var engine: Engine = .single
    
    @objc enum Engine: Int {
        case single = 0
        case multi = 1
    }
}
