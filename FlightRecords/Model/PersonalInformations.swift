//
//  PersonalInformations.swift
//  FlightRecords
//
//  Created by Martin Zid on 30/11/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//

import Foundation
import RealmSwift

final class PersonalInformations: Object {
    @objc dynamic var name: String? = nil
    @objc dynamic var surname: String? = nil
    @objc dynamic var birthDay: Date? = nil
    @objc dynamic var address: String? = nil
}
