//
//  AddPlaneViewModelTests.swift
//  FlightRecordsTests
//
//  Created by Martin Zid on 09/11/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//

import XCTest
@testable import FlightRecords

class AddPlaneViewModelTests: TestCaseBase {
    
    var viewModelUnderTest: AddPlaneViewModel!
    let se = NSLocalizedString("SE", comment: "")
    let me = NSLocalizedString("ME", comment: "")
    
    override func setUp() {
        super.setUp()
        viewModelUnderTest = AddPlaneViewModel(with: nil)
    }
    
    override func tearDown() {
        viewModelUnderTest = nil
        super.tearDown()
    }
    
    func testGetEngine() {
        let engine = viewModelUnderTest.getEngine(for: 0)
        let engine2 = viewModelUnderTest.getEngine(for: 1)
        
        XCTAssertEqual(engine, se, "ViewModel returned wrong engine.")
        XCTAssertEqual(engine2, me, "ViewModel returned wrong engine.")
    }
    
    func testGetEnginesCount() {
        let count = viewModelUnderTest.getEnginesCount()
        
        XCTAssertEqual(count, 2, "Engines count is not correct.")
    }
    
    func testEngineForValue() {
        viewModelUnderTest.engineString.value = se
        
        XCTAssertEqual(viewModelUnderTest.engine.value, Plane.Engine.single, "Engine is not set to SE type.")
    }
    
    private func createDummyPlane() -> Plane {
        let plane = Plane()
        plane.model = "Boeing"
        plane.type = "737"
        plane.variant = "800"
        plane.registrationNumber = "AB123Y"
        plane.engine = .multi
        return plane
    }
    
    func testInitWithPlane() {
        let plane = createDummyPlane()
        viewModelUnderTest = AddPlaneViewModel(with: plane)
        
        XCTAssertEqual(viewModelUnderTest.model.value, "Boeing", "Model in ViewModel is not set.")
        XCTAssertEqual(viewModelUnderTest.type.value, "737", "Type in ViewModel is not set.")
        XCTAssertEqual(viewModelUnderTest.variant.value, "800", "Variant in ViewModel is not set.")
        XCTAssertEqual(viewModelUnderTest.registrationNumber.value, "AB123Y", "Reg No. in ViewModel is not set.")
        XCTAssertEqual(viewModelUnderTest.engine.value, .multi,  "Engine in ViewModel is not set.")
        XCTAssertEqual(viewModelUnderTest.engineString.value, me, "EngineString in ViewModel is not set.")
    }
    
    func testInitWithoutPlane() {
        XCTAssertEqual(viewModelUnderTest.model.value, nil, "Model in ViewModel is set.")
        XCTAssertEqual(viewModelUnderTest.type.value, nil, "Type in ViewModel is set.")
        XCTAssertEqual(viewModelUnderTest.variant.value, nil, "Variant in ViewModel is set.")
        XCTAssertEqual(viewModelUnderTest.registrationNumber.value, nil, "Reg No. in ViewModel is set.")
        XCTAssertEqual(viewModelUnderTest.engine.value, .single,  "Engine in ViewModel is not set correctly.")
        XCTAssertEqual(viewModelUnderTest.engineString.value, se, "EngineString in ViewModel is not set correctly.")
    }
    
    func testSavePlaneToRealm() {
        viewModelUnderTest.realm = setUpRealm()
        viewModelUnderTest.savePlaneToRealm()
        
        let planes = viewModelUnderTest.realm.objects(Plane.self)
        
        XCTAssertEqual(planes.count, 1, "Plane was not saved to realm.")
    }
    
}








