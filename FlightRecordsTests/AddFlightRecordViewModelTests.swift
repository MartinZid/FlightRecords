//
//  AddFlightRecordViewModelTests.swift
//  FlightRecordsTests
//
//  Created by Martin Zid on 19/10/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//

import XCTest
import ReactiveCocoa
import ReactiveSwift
@testable import FlightRecords

class AddFlightRecordViewModelTests: XCTestCase {
    
    var viewModelUnderTest: AddFlightRecordViewModel!
    var dateFormatter: DateFormatter!
    
    override func setUp() {
        super.setUp()
        viewModelUnderTest = AddFlightRecordViewModel()
        dateFormatter = DateFormatter()
    }
    
    override func tearDown() {
        viewModelUnderTest = nil
        dateFormatter = nil
        super.tearDown()
    }
    
    func testCountTotalTime1() {
        dateFormatter.dateFormat = "HH:mm"
        let date1 = dateFormatter.date(from: "11:00")!
        let date2 = dateFormatter.date(from: "17:00")!
        viewModelUnderTest.timeTKO.value = date1
        viewModelUnderTest.timeLDG.value = date2
        
        XCTAssertEqual(viewModelUnderTest.totalTime.value, "06:00", "Total flight time is wrong.")
    }
    
    func testCountTotalTime2() {
        dateFormatter.dateFormat = "HH:mm"
        let date1 = dateFormatter.date(from: "18:00")!
        let date2 = dateFormatter.date(from: "02:00")!
        viewModelUnderTest.timeTKO.value = date1
        viewModelUnderTest.timeLDG.value = date2
        
        XCTAssertEqual(viewModelUnderTest.totalTime.value, "08:00", "Total flight time is wrong.")
    }
    
    func testDateString() {
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let date = dateFormatter.date(from: "1.10.2017")!
        viewModelUnderTest.date.value = date
        
        XCTAssertEqual(viewModelUnderTest.dateString.value, "01.10.2017", "Variable dateString is not correct.")
    }
    
    func testTimeTKOString() {
        dateFormatter.dateFormat = "HH:mm"
        let date = dateFormatter.date(from: "18:00")!
        viewModelUnderTest.timeTKO.value = date
        
        XCTAssertEqual(viewModelUnderTest.timeTKOString.value, "18:00", "Variable timeTKOString is not correct.")
    }
    
    func testTimeLDGString() {
        dateFormatter.dateFormat = "HH:mm"
        let date = dateFormatter.date(from: "02:15")!
        viewModelUnderTest.timeLDG.value = date
        
        XCTAssertEqual(viewModelUnderTest.timeLDGString.value, "02:15", "Variable timeLDGString is not correct.")
    }
    
}
