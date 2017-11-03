//
//  PlaneViewModelTests.swift
//  FlightRecordsTests
//
//  Created by Martin Zid on 02/11/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//

import XCTest

import XCTest
@testable import FlightRecords

class PlaneViewModelTests: XCTestCase {
    
    var planeUnderTest: Plane!
    var viewModelUnderTest: PlaneViewModel!
    
    override func setUp() {
        super.setUp()
        planeUnderTest = Plane()
        viewModelUnderTest = PlaneViewModel(with: planeUnderTest)
    }
    
    override func tearDown() {
        viewModelUnderTest = nil
        planeUnderTest = nil
        super.tearDown()
    }
    
    func testGetRegistrationNumber() {
        planeUnderTest.registrationNumber = "N1Q24Y"
        
        let regNo = viewModelUnderTest.getRegistrationNumber()
        
        XCTAssertEqual(regNo, "N1Q24Y", "PlaneViewModel return wrong registration number.")
    }
    
    func testGetType() {
        planeUnderTest.type = "Boeing 747-800"
        
        let type = viewModelUnderTest.getType()
        
        XCTAssertEqual(type, "Boeing 747-800", "PlaneViewModel return wrong plane type.")
    }
    
}

