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
        let date1 = dateFormatter.createDate(hours: 11, minutes: 00)
        let date2 = dateFormatter.createDate(hours: 17, minutes: 00)
        viewModelUnderTest.timeTKO.value = date1
        viewModelUnderTest.timeLDG.value = date2
        
        XCTAssertEqual(viewModelUnderTest.totalTime.value, "06:00", "Total flight time is wrong.")
    }
    
    func testCountTotalTime2() {
        let date1 = dateFormatter.createDate(hours: 18, minutes: 00)
        let date2 = dateFormatter.createDate(hours: 2, minutes: 00)
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
    
    func testTimeTKOConnection() {
        dateFormatter.dateFormat = "HH:mm"
        let date = dateFormatter.createDate(hours: 18, minutes: 0)
        viewModelUnderTest.timeTKO.value = date
        
        XCTAssertEqual(viewModelUnderTest.timeTKOString.value, "18:00", "Connection between timeTKO and timeTKOString is not correct.")
    }
    
    func testTimeLDGConnection() {
        dateFormatter.dateFormat = "HH:mm"
        let date = dateFormatter.createDate(hours: 2, minutes: 15)
        viewModelUnderTest.timeLDG.value = date
        
        XCTAssertEqual(viewModelUnderTest.timeLDGString.value, "02:15", "Connection between timeLDG and timeLDGString is not correct.")
    }
    
    func testTKODayConnection() {
        viewModelUnderTest.tkoDay.value = 2
        XCTAssertEqual(viewModelUnderTest.tkoDayString.value, "2", "Connection between tkoDay and tkoDayString is not correct.")
    }
    
    func testTKONightConnection() {
        viewModelUnderTest.tkoNight.value = 0
        XCTAssertEqual(viewModelUnderTest.tkoNightString.value, "0", "Connection between tkoNight and tkoNightString is not correct.")
    }
    
    func testLDGDayConnection() {
        viewModelUnderTest.ldgDay.value = 12
        XCTAssertEqual(viewModelUnderTest.ldgDayString.value, "12", "Connection between ldgDay and ldgDayString is not correct.")
    }
    
    func testLDGNightConnection() {
        viewModelUnderTest.ldgNight.value = 1
        XCTAssertEqual(viewModelUnderTest.ldgNightString.value, "1", "Connection between ldgNight and ldgNightString is not correct.")
    }
    
    func testTimeNightConnection() {
        dateFormatter.dateFormat = "HH:mm"
        let date = dateFormatter.createDate(hours: 3, minutes: 15)
        viewModelUnderTest.timeNight.value = date
        
        XCTAssertEqual(viewModelUnderTest.timeNightString.value, "03:15", "Connection between timeNight and timeNightString is not correct.")
    }
    
    func testTimeIFRConnection() {
        dateFormatter.dateFormat = "HH:mm"
        let date = dateFormatter.createDate(hours: 10, minutes: 00)
        viewModelUnderTest.timeIFR.value = date
        
        XCTAssertEqual(viewModelUnderTest.timeIFRString.value, "10:00", "Connection between timeIFR and timeIFRString is not correct.")
    }
    
    func testTimePICConnection() {
        dateFormatter.dateFormat = "HH:mm"
        let date = dateFormatter.createDate(hours: 10, minutes: 30)
        viewModelUnderTest.timePIC.value = date
        
        XCTAssertEqual(viewModelUnderTest.timePICString.value, "10:30", "Connection between timePIC and timePICString is not correct.")
    }
    
    func testTimeCOConnection() {
        dateFormatter.dateFormat = "HH:mm"
        let date = dateFormatter.createDate(hours: 00, minutes: 30)
        viewModelUnderTest.timeCO.value = date
        
        XCTAssertEqual(viewModelUnderTest.timeCOString.value, "00:30", "Connection between timeCO and timeCOString is not correct.")
    }
    
    func testTimeDUALConnection() {
        dateFormatter.dateFormat = "HH:mm"
        let date = dateFormatter.createDate(hours: 1, minutes: 30)
        viewModelUnderTest.timeDual.value = date
        
        XCTAssertEqual(viewModelUnderTest.timeDualString.value, "01:30", "Connection between timeDual and timeDualString is not correct.")
    }
    
    func testTimeInstructorConnection() {
        dateFormatter.dateFormat = "HH:mm"
        let date = dateFormatter.createDate(hours: 14, minutes: 00)
        viewModelUnderTest.timeInstructor.value = date
        
        XCTAssertEqual(viewModelUnderTest.timeInstructorString.value, "14:00", "Connection between timeInstructor and timeInstructorString is not correct.")
    }
    
}
