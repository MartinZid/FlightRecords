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

class RecordsViewModelTests: XCTestCase {
    
    var viewModelUnderTest: RecordsViewModel!
    
    override func setUp() {
        super.setUp()
        //Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        //let (_, _) = Signal<Void, NoError>.pipe()
        viewModelUnderTest = RecordsViewModel()
        
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testNumberOfSections() {
        let numberOfSections = viewModelUnderTest.numberOfSections()
        
        XCTAssertEqual(numberOfSections, 1, "Number of sections should return 1")
    }

}
