//
//  PersonalInformationsViewModelTests.swift
//  FlightRecordsTests
//
//  Created by Martin Zid on 07/12/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//

import XCTest
import RealmSwift
import ReactiveCocoa
import ReactiveSwift
import Result
@testable import FlightRecords

class PersonalInformationsViewModelTests: TestCaseBase {
    
    var viewModelUnderTest: PersonalInformationsViewModel!
    var dateFormatter: DateFormatter!
    
    override func setUp() {
        super.setUp()
        viewModelUnderTest = PersonalInformationsViewModel()
        dateFormatter = DateFormatter()
    }
    
    override func tearDown() {
        viewModelUnderTest = nil
        dateFormatter = nil
        super.tearDown()
    }
    
    func testObserversNotificationAfterDataIsSet() {
        let promise = expectation(description: "observers recieved notification")
        
        viewModelUnderTest.dataSetSignal.observeValues {
            promise.fulfill()
        }
        
        viewModelUnderTest.realm = setUpRealm()
        viewModelUnderTest.realmInitCompleted()
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testBirthDayConnection() {
        viewModelUnderTest.birthDay.value = Date()
        let value = viewModelUnderTest.birthDayString.value
        
        XCTAssertEqual(value, dateFormatter.dateToString(from: Date()), "birthDayString is not correctly set.")
    }
    
    func testSetPropertiesFromModel() {
        viewModelUnderTest.realm = setUpRealm()
        try! viewModelUnderTest.realm.write {
            let info = PersonalInformations()
            info.name = "Martin"
            info.address = "Liberec"
            viewModelUnderTest.realm.add(info)
        }
        viewModelUnderTest.realmInitCompleted()

        XCTAssertEqual(viewModelUnderTest.address.value, "Liberec", "Address is not set.")
        XCTAssertEqual(viewModelUnderTest.name.value, "Martin", "Name is not set.")
    }
    
    func testSaveInfo() {
        viewModelUnderTest.realm = setUpRealm()
        viewModelUnderTest.realmInitCompleted()
        viewModelUnderTest.birthDay.value = dateFormatter.createDate(hours: 1, minutes: 0)
        viewModelUnderTest.surname.value = "Snow"
        viewModelUnderTest.saveInfo()
        
        let savedInfo = viewModelUnderTest.realm.objects(PersonalInformations.self).first
        XCTAssertEqual(savedInfo?.birthDay, dateFormatter.createDate(hours: 1, minutes: 0), "Saved info has wrong properties.")
        XCTAssertEqual(savedInfo?.surname, "Snow", "Saved info has wrong properties.")
    }
    
}





