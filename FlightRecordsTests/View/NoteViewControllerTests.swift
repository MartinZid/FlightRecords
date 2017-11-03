//
//  NoteViewControllerTests.swift
//  FlightRecordsTests
//
//  Created by Martin Zid on 03/11/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//

import XCTest
@testable import FlightRecords

class NoteViewControllerTests: XCTestCase {
    
    var controllerUnderTest: NoteViewController!
    
    override func setUp() {
        super.setUp()
        controllerUnderTest = UIStoryboard(name: "addFlightRecord", bundle: nil).instantiateViewController(withIdentifier: "Note") as! NoteViewController
    }
    
    override func tearDown() {
        controllerUnderTest = nil
        super.tearDown()
    }
    
    class MockDelegate: NoteViewControllerDelegate {
        var note: String?
        func save(note: String) {
            self.note = note
        }
    }
    
    @objc func mockAction() {}
    
//    func testSaveActionGetsDelegate() {
//        controllerUnderTest.note = "note"
//        let mockDelegate = MockDelegate()
//        controllerUnderTest.delegate = mockDelegate
//        controllerUnderTest.loadView()
//        controllerUnderTest.viewDidLoad()
//
//        let btn = controllerUnderTest.saveBtn!
//        
//        UIApplication.shared.sendAction(btn.action!, to: btn.target, from: nil, for: nil)
//
//        XCTAssertEqual(mockDelegate.note, "note", "Wrong note delegated.")
//    }
    
}
