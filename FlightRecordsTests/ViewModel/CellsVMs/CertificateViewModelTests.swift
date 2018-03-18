//
//  CertificateViewModelTests.swift
//  FlightRecordsTests
//
//  Created by Martin Zid on 08/12/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//

import XCTest
@testable import FlightRecords

class CertificateViewModelTests: XCTestCase {

    var certificateUnderTest: MedicalCertificate!
    var viewModelUnderTest: CertificateViewModel!
    
    override func setUp() {
        super.setUp()
        certificateUnderTest = MedicalCertificate()
        viewModelUnderTest = CertificateViewModel(with: certificateUnderTest)
    }
    
    override func tearDown() {
        viewModelUnderTest = nil
        certificateUnderTest = nil
        super.tearDown()
    }
    
    func testGetCertificateExpiration() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let date = formatter.date(from: "1.12.2017")
        certificateUnderTest.expirationDate = date
        
        XCTAssertEqual(viewModelUnderTest.getCertificateExpiration(), "01.12.2017", "Returned expiration date is not correct.")
    }
    
    func testGetCertificateExpiration2() {
        XCTAssertEqual(viewModelUnderTest.getCertificateExpiration(), NSLocalizedString("N/A", comment: ""), "Returned expiration date for nil value is not N/A.")
    }
    
    func testgetCertificateName() {
        certificateUnderTest.name = "Class 1"
        
        XCTAssertEqual(viewModelUnderTest.getCertificateName(), "Class 1", "Returned certificate name is not correct.")
    }
    
    func testgetCertificateName2() {
        XCTAssertEqual(viewModelUnderTest.getCertificateName(), NSLocalizedString("Without name", comment: ""), "Returned certificate name for nil is not correct.")
    }
}
