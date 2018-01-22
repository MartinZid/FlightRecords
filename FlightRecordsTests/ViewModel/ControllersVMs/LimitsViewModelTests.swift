//
//  LimitsViewModelTests.swift
//  FlightRecordsTests
//
//  Created by Martin Zid on 07/12/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//

import XCTest

@testable import FlightRecords

class LimitsViewModelTests: TestCaseBase {
    
    var viewModelUnderTest: LimitsViewModel!
    var dateFormatter: DateFormatter!
    private let day: Double = 60 * 60 * 24
    
    override func setUp() {
        super.setUp()
        viewModelUnderTest = LimitsViewModel()
        dateFormatter = DateFormatter()
        insertDummyRecords()
    }
    
    func insertDummyRecords() {
        viewModelUnderTest.realm = setUpRealm()
        try! viewModelUnderTest.realm.write {
            let r1 = Record()
            r1.date = Date().addingTimeInterval(-(29 * day))
            r1.time = "15:00"
            viewModelUnderTest.realm.add(r1)
            
            let r2 = Record()
            r2.date = Date()
            r2.time = "2:00"
            viewModelUnderTest.realm.add(r2)
            
            let r3 = Record()
            r3.date = Date().addingTimeInterval(-(2 * day))
            r3.time = "5:00"
            viewModelUnderTest.realm.add(r3)
            
            let r4 = Record()
            r4.date = dateFormatter.getDateYearAgo(from: Date()).addingTimeInterval(day)
            r4.time = "1:30"
            viewModelUnderTest.realm.add(r4)
        }
    }
    
    override func tearDown() {
        viewModelUnderTest = nil
        dateFormatter = nil
        super.tearDown()
    }
    
    func testStringTimeToFloatFuncion() {
        viewModelUnderTest.inDaysString.value = "10:30"
        
        XCTAssertEqual(viewModelUnderTest.inDays.value, 10.5, "inDays value is not correct.")
    }
    
    func testCountFlightTime() {
        viewModelUnderTest.realmInitCompleted()
        
        XCTAssertEqual(viewModelUnderTest.inDaysString.value, "7:00", "Flight hours in last 28 day are not calculated correctly.")
        XCTAssertEqual(viewModelUnderTest.inMonthsString.value, "23:30", "Flight hours in last 12 months are not calculated correctly.")
    }
}







