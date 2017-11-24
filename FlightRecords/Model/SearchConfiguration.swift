//
//  SearchConfiguration.swift
//  FlightRecords
//
//  Created by Martin Zid on 24/11/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//

import Foundation

class SearchConfiguration {
    
    var searchText: String? = nil
    var flightsSwitch: Bool = true
    var fstdSwitch: Bool = true
    var planeType: String? = nil
    var plane: Plane? = nil
    
    var fromDate: Date? = nil
    var toDate: Date? = nil
}
