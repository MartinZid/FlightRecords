//
//  SearchViewModelTests.swift
//  FlightRecordsTests
//
//  Created by Martin Zid on 29/11/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//

import XCTest
import ReactiveCocoa
import ReactiveSwift
@testable import FlightRecords

class SearchViewModelTests: XCTestCase {
    
    var viewModelUnderTest: SearchViewModel!
    var dateFormatter: DateFormatter!
    
    override func setUp() {
        super.setUp()
        viewModelUnderTest = SearchViewModel(with: nil)
        dateFormatter = DateFormatter()
    }
    
    override func tearDown() {
        viewModelUnderTest = nil
        dateFormatter = nil
        super.tearDown()
    }
    
    func testInitWithoutConfiguration() {
        XCTAssertEqual(viewModelUnderTest.searchText.value, nil, "searchText is set to wrong value.")
        XCTAssertEqual(viewModelUnderTest.fstdSwitch.value, true, "fstdSwitch is set to wrong value.")
        XCTAssertEqual(viewModelUnderTest.flightsSwitch.value, true, "flightsSwitch is set to wrong value.")
        XCTAssertEqual(viewModelUnderTest.planeType.value, nil, "planeType is set to wrong value.")
        XCTAssertEqual(viewModelUnderTest.plane.value, nil, "plane is set to wrong value.")
        XCTAssertEqual(viewModelUnderTest.fromDate.value, nil, "fromDate is set to wrong value.")
        XCTAssertEqual(viewModelUnderTest.toDate.value, nil, "toDate is set to wrong value.")
    }
    
    func testFromDateBinding() {
        viewModelUnderTest.fromDate.value = dateFormatter.createDate(hours: 10, minutes: 10)
        
        let dateString = dateFormatter.dateToString(from: dateFormatter.createDate(hours: 10, minutes: 10))
        
        XCTAssertEqual(viewModelUnderTest.fromDateString.value, dateString, "fromDate binding is not correct.")
    }
    
    func testFromDateBinding2() {
        let dateString: String? = nil
        
        XCTAssertEqual(viewModelUnderTest.fromDateString.value, dateString, "fromDate binding is not correct.")
    }
    
    func testToDateBinding() {
        viewModelUnderTest.toDate.value = dateFormatter.createDate(hours: 10, minutes: 10)
        
        let dateString = dateFormatter.dateToString(from: dateFormatter.createDate(hours: 10, minutes: 10))
        
        XCTAssertEqual(viewModelUnderTest.toDateString.value, dateString, "toDate binding is not correct.")
    }
    
    func testToDateBinding2() {
        let dateString: String? = nil
        
        XCTAssertEqual(viewModelUnderTest.toDateString.value, dateString, "toDate binding is not correct.")
    }
    
    func testsetDefaultToDateValue() {
        viewModelUnderTest.fromDate.value = Date().addingTimeInterval(24 * 60 * 60)
        
        viewModelUnderTest.setDefaultToDateValue()
        
        let toDateValue = dateFormatter.dateToString(from: viewModelUnderTest.toDate.value!)
        let correctValue = dateFormatter.dateToString(from: viewModelUnderTest.fromDate.value!)
        
        XCTAssertEqual(toDateValue, correctValue, "toDate is set to wrong value.")    }
    
    func testsetDefaultToDateValue2() {
        viewModelUnderTest.fromDate.value = Date().addingTimeInterval( -(24 * 60 * 60))
        
        viewModelUnderTest.setDefaultToDateValue()
        
        let toDateValue = dateFormatter.dateToString(from: viewModelUnderTest.toDate.value!)
        let correctValue = dateFormatter.dateToString(from: Date())
        
        XCTAssertEqual(toDateValue, correctValue, "toDate is set to wrong value.")
    }
    
    func testsetDefaultToDateValue3() {
        viewModelUnderTest.fromDate.value = nil
        
        viewModelUnderTest.setDefaultToDateValue()
        
        let toDateValue = dateFormatter.dateToString(from: viewModelUnderTest.toDate.value!)
        let correctValue = dateFormatter.dateToString(from: Date())
        
        XCTAssertEqual(toDateValue, correctValue, "toDate is set to wrong value.")
    }
    
    func testToDateValueChangesFromDateValue() {
        viewModelUnderTest.toDate.value = Date().addingTimeInterval( -(24 * 60 * 60))
        viewModelUnderTest.fromDate.value = Date()
        
        let toDateValue = dateFormatter.dateToString(from: viewModelUnderTest.toDate.value!)
        let correctValue = dateFormatter.dateToString(from: Date())
        
        XCTAssertEqual(toDateValue, correctValue, "toDate is set to wrong value.")
    }
    
    func testToDateValueChangesFromDateValue2() {
        viewModelUnderTest.toDate.value = Date().addingTimeInterval(24 * 60 * 60)
        viewModelUnderTest.fromDate.value = Date()
        
        let toDateValue = dateFormatter.dateToString(from: viewModelUnderTest.toDate.value!)
        let correctValue = dateFormatter.dateToString(from: Date().addingTimeInterval(24 * 60 * 60))
        
        XCTAssertEqual(toDateValue, correctValue, "toDate is set to wrong value.")
        
        viewModelUnderTest.fromDate.value = nil
        
        XCTAssertEqual(toDateValue, correctValue, "toDate is set to wrong value.")
    }
    
    func testGetConfiguration() {
        viewModelUnderTest.searchText.value = "search"
        let plane = Plane()
        viewModelUnderTest.plane.value = plane
        
        let configuration = viewModelUnderTest.getConfiguration()
        
        XCTAssertEqual(configuration.searchText, "search")
        XCTAssertEqual(configuration.plane, plane)
    }
    
    func testClearSearchParameters() {
        XCTAssertEqual(viewModelUnderTest.searchText.value, nil, "searchText is set to wrong value.")
        XCTAssertEqual(viewModelUnderTest.fstdSwitch.value, true, "fstdSwitch is set to wrong value.")
        XCTAssertEqual(viewModelUnderTest.flightsSwitch.value, true, "flightsSwitch is set to wrong value.")
        XCTAssertEqual(viewModelUnderTest.planeType.value, nil, "planeType is set to wrong value.")
        XCTAssertEqual(viewModelUnderTest.plane.value, nil, "plane is set to wrong value.")
        XCTAssertEqual(viewModelUnderTest.fromDate.value, nil, "fromDate is set to wrong value.")
        XCTAssertEqual(viewModelUnderTest.toDate.value, nil, "toDate is set to wrong value.")
    }
    
}









