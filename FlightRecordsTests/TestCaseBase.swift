//
//  TestCaseBase.swift
//  FlightRecordsTests
//
//  Created by Martin Zid on 14/10/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//

import XCTest
import RealmSwift

class TestCaseBase: XCTestCase {
    override func setUp() {
        super.setUp()
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
    }
    override func tearDown() {
        super.tearDown()
    }
    
    func setUpRealm() -> Realm {
        var config = Realm.Configuration.defaultConfiguration
        config.inMemoryIdentifier = self.name
        return try! Realm(configuration: config)
    }
}
