//
//  StatisticsViewModelTests.swift
//  FlightRecordsTests
//
//  Created by Martin Zid on 22/01/2018.
//  Copyright © 2018 Martin Zid. All rights reserved.
//

import XCTest

@testable import FlightRecords

class StatisticsViewModelTests: TestCaseBase {
    
    var viewModelUnderTest: StatisticsViewModel!
    var dateFormatter: DateFormatter!
    
    override func setUp() {
        super.setUp()
        viewModelUnderTest = StatisticsViewModel()
        dateFormatter = DateFormatter()
        viewModelUnderTest.realm = setUpRealm()
    }
    
    override func tearDown() {
        viewModelUnderTest = nil
        dateFormatter = nil
        super.tearDown()
    }
    
    func testCalculationForEmptyRecords() {
        viewModelUnderTest.realmInitCompleted()
        XCTAssertEqual(viewModelUnderTest.totalTimeString.value, "0:00", "Time is not zero.")
        XCTAssertEqual(viewModelUnderTest.nightTimeString.value, "0:00", "Time is not zero.")
        XCTAssertEqual(viewModelUnderTest.ifrTimeString.value, "0:00", "Time is not zero.")
        XCTAssertEqual(viewModelUnderTest.picTimeString.value, "0:00", "Time is not zero.")
        XCTAssertEqual(viewModelUnderTest.coTimeString.value, "0:00", "Time is not zero.")
        XCTAssertEqual(viewModelUnderTest.dualTimeString.value, "0:00", "Time is not zero.")
        XCTAssertEqual(viewModelUnderTest.instructorTimeString.value, "0:00", "Time is not zero.")
    }
    
    private func insertDummyRecords() {
        try! viewModelUnderTest.realm.write {
            let r1 = Record()
            r1.time = "02:00"
            r1.timeNight = dateFormatter.createDate(hours: 10, minutes: 30)
            r1.timeIFR = dateFormatter.createDate(hours: 1, minutes: 0)
            r1.timePIC = dateFormatter.createDate(hours: 12, minutes: 20)
            r1.timeCO = dateFormatter.createDate(hours: 2, minutes: 0)
            r1.timeDUAL = dateFormatter.createDate(hours: 23, minutes: 0)
            r1.timeInstructor = dateFormatter.createDate(hours: 0, minutes: 10)
            viewModelUnderTest.realm.add(r1)
            
            let r2 = Record()
            r2.time = "10:45"
            r2.timeNight = dateFormatter.createDate(hours: 2, minutes: 30)
            r2.timePIC = dateFormatter.createDate(hours: 1, minutes: 45)
            r2.timeDUAL = dateFormatter.createDate(hours: 1, minutes: 0)
            viewModelUnderTest.realm.add(r2)
        }
    }
    
    func testCalculationsWithRecords() {
        insertDummyRecords()
        viewModelUnderTest.realmInitCompleted()
        XCTAssertEqual(viewModelUnderTest.totalTimeString.value, "12:45", "Time calculation is wrong.")
        XCTAssertEqual(viewModelUnderTest.nightTimeString.value, "13:00", "Time calculation is wrong.")
        XCTAssertEqual(viewModelUnderTest.ifrTimeString.value, "1:00", "Time calculation is wrong.")
        XCTAssertEqual(viewModelUnderTest.picTimeString.value, "14:05", "Time calculation is wrong.")
        XCTAssertEqual(viewModelUnderTest.coTimeString.value, "2:00", "Time calculation is wrong.")
        XCTAssertEqual(viewModelUnderTest.dualTimeString.value, "24:00", "Time calculation is wrong.")
        XCTAssertEqual(viewModelUnderTest.instructorTimeString.value, "0:10", "Time calculation is wrong.")
    }
    
    func testGetSearchViewModel() {
        let searchVM = viewModelUnderTest.getSearchViewModel()
        XCTAssert((searchVM as Any) is SearchViewModel)
    }
    
}
