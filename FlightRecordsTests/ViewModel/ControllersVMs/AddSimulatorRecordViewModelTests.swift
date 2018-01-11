//
//  AddSimulatorRecordViewModelTests.swift
//  FlightRecordsTests
//
//  Created by Martin Zid on 16/11/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//

import XCTest
import ReactiveCocoa
import ReactiveSwift
@testable import FlightRecords

class AddSimulatorRecordViewModelTests: TestCaseBase {
    
    var viewModelUnderTest: AddSimulatorRecordViewModel!
    var dateFormatter: DateFormatter!
    
    override func setUp() {
        super.setUp()
        viewModelUnderTest = AddSimulatorRecordViewModel(with: nil)
        dateFormatter = DateFormatter()
    }
    
    override func tearDown() {
        viewModelUnderTest = nil
        dateFormatter = nil
        super.tearDown()
    }
    
    private func createDummyRecord() -> Record {
        let record = Record()
        record.date = dateFormatter.createDate(hours: 14, minutes: 30)
        record.time = "10:10"
        record.simulator = "FNTP II"
        record.note = "note"
        return record
    }
    
    // init
    func testInitWithoutRecord() {
        XCTAssertEqual(viewModelUnderTest.time.value, dateFormatter.createDate(hours: 0, minutes: 0), "Time is not set to zero.")
        XCTAssertEqual(viewModelUnderTest.type.value, nil, "Type is not nil.")
        XCTAssertEqual(viewModelUnderTest.note.value, nil, "Note is not nil.")
    }
    
    func testInitWithRecord() {
        let record = createDummyRecord()
        viewModelUnderTest = AddSimulatorRecordViewModel(with: record)
        XCTAssertEqual(viewModelUnderTest.date.value, dateFormatter.createDate(hours: 14, minutes: 30), "Date is not correct.")
        XCTAssertEqual(viewModelUnderTest.time.value, dateFormatter.createDate(hours: 10, minutes: 10), "Time is not correct.")
        XCTAssertEqual(viewModelUnderTest.type.value, "FNTP II", "Type is not correct.")
        XCTAssertEqual(viewModelUnderTest.note.value, "note", "Note is not correct.")
    }
    
    // connections
    func testDateConnection() {
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let date = dateFormatter.date(from: "12.10.2017")!
        viewModelUnderTest.date.value = date
        
        XCTAssertEqual(viewModelUnderTest.dateString.value, "12.10.2017", "dateString is set to wrong value.")
    }
    
    func testTimeConnection() {
        let time = dateFormatter.createDate(hours: 15, minutes: 55)
        viewModelUnderTest.time.value = time
        
        XCTAssertEqual(viewModelUnderTest.timeString.value, "15:55", "timeString is set to wrong value.")
    }
    
}





