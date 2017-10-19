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
    
    func createDate(hours: Int, minutes: Int) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        let now = Date()
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: now)
        components.hour = hours
        components.minute = minutes
        return calendar.date(from: components)!
    }
    
    func testCountTotalTime1() {
        let date1 = createDate(hours: 11, minutes: 00)
        let date2 = createDate(hours: 17, minutes: 00)
        viewModelUnderTest.timeTKO.value = date1
        viewModelUnderTest.timeLDG.value = date2
        
        XCTAssertEqual(viewModelUnderTest.totalTime.value, "06:00", "Total flight time is wrong.")
    }
    
    func testCountTotalTime2() {
        let date1 = createDate(hours: 18, minutes: 00)
        let date2 = createDate(hours: 2, minutes: 00)
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
        let date = createDate(hours: 18, minutes: 0)
        viewModelUnderTest.timeTKO.value = date
        
        XCTAssertEqual(viewModelUnderTest.timeTKOString.value, "18:00", "Connection between timeTKO and timeTKOString is not correct.")
    }
    
    func testTimeLDGConnection() {
        dateFormatter.dateFormat = "HH:mm"
        let date = createDate(hours: 2, minutes: 15)
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
    
}
