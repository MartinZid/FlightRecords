//
//  RecordViewModelTests.swift
//  FlightRecordsTests
//
//  Created by Martin Zid on 13/10/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//

import XCTest
@testable import FlightRecords

class RecordViewModelTests: XCTestCase {
    
    var recordUnderTest: Record!
    var viewModelUnderTest: RecordViewModel!
    
    override func setUp() {
        super.setUp()
        recordUnderTest = Record()
        viewModelUnderTest = RecordViewModel(with: recordUnderTest)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // getDate
    func testDateIsCorrectlyConverted() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let date = formatter.date(from: "1.10.2017")
        recordUnderTest.date = date
        
        let dateString = viewModelUnderTest.getDate()

        XCTAssertEqual(dateString, "01.10.2017", "Date is not correctly converted.")
    }
    
    func testGetDateReturnEmptyStringWhenNotSet() {
        let dateString = viewModelUnderTest.getDate()

        XCTAssertEqual(dateString, "", "Result should be empty String.")
    }
    
    //getDestinations
    func testgetDestinationsCreatesCorrectString() {
        recordUnderTest.from = "PRG"
        recordUnderTest.to = "PRG"
        
        let destinations = viewModelUnderTest.getDestinations()
        
        XCTAssertEqual(destinations, "PRG-PRG", "Destinations are not in correct format.")
        
    }
    
    // getTime
    func testgetTimeGeneratesCorrectString() {
        recordUnderTest.time = 2
        
        let time = viewModelUnderTest.getTime()
        
        XCTAssertEqual(time, "2 h", "Time is not in correctly generated.")
    }
    
    //getPlane
    func testgetPlaneShouldReturnRecordsPlane() {
        let plane = Plane()
        plane.registrationNumber = "N123Q0"
        recordUnderTest.plane = plane
        
        let testPlane = viewModelUnderTest.getPlane()
        
        XCTAssertEqual(testPlane, plane, "Returned plane adn given plane differs.")
    }
    
}
