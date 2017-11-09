//
//  PlaneViewModelTests.swift
//  FlightRecordsTests
//
//  Created by Martin Zid on 02/11/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//

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
    
    func testGetRegistrationNumberEmpty() {
        let regNo = viewModelUnderTest.getRegistrationNumber()
        
        XCTAssertEqual(regNo, NSLocalizedString("N/A", comment: ""), "PlaneViewModel return wrong registration number.")
    }
    
    func testGetPlaneInfo() {
        planeUnderTest.type = "Boeing"
        planeUnderTest.model = "737"
        planeUnderTest.variant = "800"
        
        let info = viewModelUnderTest.getPlaneInfo()
        
        XCTAssertEqual(info, "Boeing 737-800", "PlaneViewModel return wrong plane info.")
    }
    
    func testGetPlaneInfoWithoutModel() {
        planeUnderTest.type = "Boeing"
        planeUnderTest.variant = "800"
        
        let info = viewModelUnderTest.getPlaneInfo()
        
        XCTAssertEqual(info, "Boeing 800", "PlaneViewModel return wrong plane info.")
    }
    
    func testGetPlaneInfoWithoutVariant() {
        planeUnderTest.type = "Boeing"
        planeUnderTest.model = "737"
        
        let info = viewModelUnderTest.getPlaneInfo()
        
        XCTAssertEqual(info, "Boeing 737", "PlaneViewModel return wrong plane info.")
    }
    
    func testGetPlaneInfoWithoutEverthing() {
        let info = viewModelUnderTest.getPlaneInfo()
        
        XCTAssertEqual(info, NSLocalizedString("N/A", comment: ""), "PlaneViewModel return wrong plane info.")
    }
    
}

