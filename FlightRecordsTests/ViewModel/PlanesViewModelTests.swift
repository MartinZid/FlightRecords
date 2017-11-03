//
//  PlanesViewModelTests.swift
//  FlightRecordsTests
//
//  Created by Martin Zid on 03/11/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//

import XCTest
import RealmSwift
import ReactiveCocoa
import ReactiveSwift
import Result
@testable import FlightRecords

class PlanesViewModelTests: TestCaseBase {
    
    var viewModelUnderTest: PlanesViewModel!
    
    override func setUp() {
        super.setUp()
        viewModelUnderTest = PlanesViewModel()
    }
    
    override func tearDown() {
        viewModelUnderTest = nil
        super.tearDown()
    }
    
    func testNumberOfSections() {
        let numberOfSections = viewModelUnderTest.numberOfSections()
        
        XCTAssertEqual(numberOfSections, 1, "Number of sections should return 1")
    }
    
    func testNumberOfPlanes() {
        viewModelUnderTest.realm = setUpRealm()
        try! viewModelUnderTest.realm.write {
            viewModelUnderTest.realm.add(Plane())
            viewModelUnderTest.realm.add(Plane())
        }
        viewModelUnderTest.realmInitCompleted()
        
        let numberOfRecords = viewModelUnderTest.numberOfPlanesInSection()
        
        XCTAssertEqual(numberOfRecords, 2, "Number of planes is wrong.")
    }
    
    func testRealmSetUpInformingOberversOnComplete() {
        let promise = expectation(description: "observers recieved notification")
        
        viewModelUnderTest.contentChangedSignal.observeValues {
            promise.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGetCellViewModel() {
        let plane = Plane()
        plane.type = "Boeing 737"
        viewModelUnderTest.realm = setUpRealm()
        try! viewModelUnderTest.realm.write {
            viewModelUnderTest.realm.add(plane)
        }
        viewModelUnderTest.realmInitCompleted()
        
        let indexPath = IndexPath(row: 0, section: 0)
        let recievedVM = viewModelUnderTest.getCellViewModel(for: indexPath)
        
        XCTAssertEqual(recievedVM.getType(), "Boeing 737", "Plane in recieved VM is not correct.")
    }
    
}

