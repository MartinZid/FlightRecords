//
//  PlanesTableViewControllerTests.swift
//  FlightRecordsTests
//
//  Created by Martin Zid on 03/11/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//

import XCTest
@testable import FlightRecords

class PlanesTableViewControllerTests: XCTestCase {
    
    var controllerUnderTest: PlanesTableViewController!
    
    override func setUp() {
        super.setUp()
        controllerUnderTest = UIStoryboard(name: "planes", bundle: nil).instantiateViewController(withIdentifier: "Planes") as? PlanesTableViewController
    }
    
    override func tearDown() {
        controllerUnderTest = nil
        super.tearDown()
    }
    
    func testReloadDateIsCalledAfterRealmIsSetUp() {
        let promise = expectation(description: "reload data was called")
        class MockTableView: UITableView {
            var expectation: XCTestExpectation?
            override func reloadData() {
                expectation!.fulfill()
            }
        }
        
        let mockTableView = MockTableView()
        mockTableView.expectation = promise
        controllerUnderTest.tableView = mockTableView
        controllerUnderTest.viewDidLoad()
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}

