//
//  RecordsTableViewControllerTests.swift
//  FlightRecordsTests
//
//  Created by Martin Zid on 14/10/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//

import XCTest
@testable import FlightRecords

class RecordsTableViewControllerTests: XCTestCase {
    
    var controllerUnderTest: RecordsTableViewController!
    
    override func setUp() {
        super.setUp()
        controllerUnderTest = UIStoryboard(name: "records", bundle: nil).instantiateViewController(withIdentifier: "Records") as? RecordsTableViewController
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
