//
//  RecordsViewModelTests.swift
//  FlightRecordsTests
//
//  Created by Martin Zid on 13/10/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//

import XCTest
import RealmSwift
import ReactiveCocoa
import ReactiveSwift
import Result
@testable import FlightRecords

class RecordsViewModelTests: TestCaseBase {
    
    var viewModelUnderTest: RecordsViewModel!
    
    override func setUp() {
        super.setUp()
        viewModelUnderTest = RecordsViewModel()
    }
    
    override func tearDown() {
        viewModelUnderTest = nil
        super.tearDown()
    }
    
    func testNumberOfSections() {
        let numberOfSections = viewModelUnderTest.numberOfSections()
        
        XCTAssertEqual(numberOfSections, 1, "Number of sections should return 1")
    }
    
    func testNumberOfRecords() {
        viewModelUnderTest.realm = setUpRealm()
        try! viewModelUnderTest.realm.write {
            viewModelUnderTest.realm.add(Record())
            viewModelUnderTest.realm.add(Record())
        }
        viewModelUnderTest.realmInitCompleted()
        
        let numberOfRecords = viewModelUnderTest.numberOfRecordsInSection()
            
        XCTAssertEqual(numberOfRecords, 2, "Number of records is wrong.")
    }
    
    func testRealmSetUpInformingOberversOnComplete() {
        let promise = expectation(description: "observers recieved notification")
        
        viewModelUnderTest.recordsChangedSignal.observeValues { changes in
            promise.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGetCellViewModel() {
        let record = Record()
        record.time = "2"
        viewModelUnderTest.realm = setUpRealm()
        try! viewModelUnderTest.realm.write {
            viewModelUnderTest.realm.add(record)
        }
        viewModelUnderTest.realmInitCompleted()
        
        let indexPath = IndexPath(row: 0, section: 0)
        let recievedVM = viewModelUnderTest.getCellViewModel(for: indexPath)
        
        XCTAssertEqual(recievedVM.getTime(), "2 h", "Record in recieved VM is not correct.")
    }

}
