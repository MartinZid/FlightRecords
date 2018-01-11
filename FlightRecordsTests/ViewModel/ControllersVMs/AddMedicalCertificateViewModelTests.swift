//
//  AddMedicalCertificateViewModelTests.swift
//  FlightRecordsTests
//
//  Created by Martin Zid on 11/01/2018.
//  Copyright © 2018 Martin Zid. All rights reserved.
//

import XCTest

@testable import FlightRecords

class AddMedicalCertificateViewModelTests: TestCaseBase {
    
    var viewModelUnderTest: AddMedicalCertificateViewModel!
    var dateFormatter: DateFormatter!
    
    override func setUp() {
        super.setUp()
        viewModelUnderTest = AddMedicalCertificateViewModel(with: nil)
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatter.Format.date
    }
    
    override func tearDown() {
        viewModelUnderTest = nil
        dateFormatter = nil
        super.tearDown()
    }
    
    private func createDummyCertificate() -> MedicalCertificate {
        let certificate = MedicalCertificate()
        certificate.name = "Name"
        certificate.type = .class1
        certificate.publicationDate = dateFormatter.date(from: "12.12.2017")
        certificate.expirationDate = dateFormatter.date(from: "12.12.2018")
        certificate.note = "note"
        return certificate
    }
    
    func testgetTypesCount() {
        let count = viewModelUnderTest.getTypesCount()
        XCTAssertEqual(count, 4, "Types count is wrong.")
    }
    
    func testSaveCertificateToRealm() {
        viewModelUnderTest.realm = setUpRealm()
        viewModelUnderTest.saveCertificateToRealm()
        
        let planes = viewModelUnderTest.realm.objects(MedicalCertificate.self)
        
        XCTAssertEqual(planes.count, 1, "Plane was not saved to realm.")
    }
    
    func testInitWithCertificate() {
        let certificate = createDummyCertificate()
        viewModelUnderTest = AddMedicalCertificateViewModel(with: certificate)
        XCTAssertEqual(viewModelUnderTest.name.value, "Name", "Name in ViewModel is not set.")
        XCTAssertEqual(viewModelUnderTest.type.value, .class1, "Type in ViewModel is not set.")
        XCTAssertEqual(viewModelUnderTest.publicationString.value, "12.12.2017", "Publication in ViewModel is not set.")
        XCTAssertEqual(viewModelUnderTest.expirationString.value, "12.12.2018", "Expiration in ViewModel is not set.")
        XCTAssertEqual(viewModelUnderTest.description.value, "note", "Note in ViewModel is not set.")
    }
    
    func testInitWithoutCertificate() {
        XCTAssertEqual(viewModelUnderTest.name.value, nil, "Name in ViewModel is set.")
        XCTAssertEqual(viewModelUnderTest.type.value, .LALP, "Type is not set to default value.")
        XCTAssertEqual(viewModelUnderTest.publication.value, nil, "Publication in ViewModel is set.")
        XCTAssertEqual(viewModelUnderTest.expiration.value, nil, "Expiration in ViewModel is set.")
        XCTAssertEqual(viewModelUnderTest.description.value, nil, "Note in ViewModel is set.")
    }
    
    func testTypeForString() {
        viewModelUnderTest.typeString.value = NSLocalizedString("LALP", comment: "")
        XCTAssertEqual(viewModelUnderTest.type.value, .LALP, "Type is not coresponding to given string.")
        
        viewModelUnderTest.typeString.value = NSLocalizedString("Class1", comment: "")
        XCTAssertEqual(viewModelUnderTest.type.value, .class1, "Type is not coresponding to given string.")
        
        viewModelUnderTest.typeString.value = NSLocalizedString("Class2", comment: "")
        XCTAssertEqual(viewModelUnderTest.type.value, .class2, "Type is not coresponding to given string.")
        
        viewModelUnderTest.typeString.value = NSLocalizedString("Custom", comment: "")
        XCTAssertEqual(viewModelUnderTest.type.value, .custom, "Type is not coresponding to given string.")
    }
    
    func testCountExpirationDateWithLALPUnder40() {
        viewModelUnderTest.informations = PersonalInformations()
        viewModelUnderTest.informations!.birthDay = dateFormatter.date(from: "12.12.2017") // under 40
        viewModelUnderTest.publication.value = dateFormatter.date(from: "10.12.2017")
        viewModelUnderTest.type.value = .LALP
        
        let expiration = viewModelUnderTest.expirationString.value!
        
        XCTAssertEqual(expiration, "10.12.2022", "Expiration date is not correct.")
    }
    
    func testCountExpirationDateWithLALPOver40() {
        viewModelUnderTest.informations = PersonalInformations()
        viewModelUnderTest.informations!.birthDay = dateFormatter.date(from: "12.12.1917") // over 40
        viewModelUnderTest.publication.value = dateFormatter.date(from: "10.12.2017")
        viewModelUnderTest.type.value = .LALP
        
        let expiration = viewModelUnderTest.expirationString.value!
        
        XCTAssertEqual(expiration, "10.12.2019", "Expiration date is not correct.")
    }
    
    func testCountExpirationDateWithClass2Under40() {
        viewModelUnderTest.informations = PersonalInformations()
        viewModelUnderTest.informations!.birthDay = dateFormatter.date(from: "12.12.2017") // over 40
        viewModelUnderTest.publication.value = dateFormatter.date(from: "10.12.2017")
        viewModelUnderTest.type.value = .class2
        
        let expiration = viewModelUnderTest.expirationString.value!
        
        XCTAssertEqual(expiration, "10.12.2022", "Expiration date is not correct.")
    }
    
    func testCountExpirationDateWithClass2Under50() {
        viewModelUnderTest.informations = PersonalInformations()
        viewModelUnderTest.informations!.birthDay = dateFormatter.date(from: "12.12.1975") // over 40 under 50
        viewModelUnderTest.publication.value = dateFormatter.date(from: "10.12.2017")
        viewModelUnderTest.type.value = .class2
        
        let expiration = viewModelUnderTest.expirationString.value!
        
        XCTAssertEqual(expiration, "10.12.2019", "Expiration date is not correct.")
    }
    
    func testCountExpirationDateWithClass2Over50() {
        viewModelUnderTest.informations = PersonalInformations()
        viewModelUnderTest.informations!.birthDay = dateFormatter.date(from: "12.12.1917") // over 50
        viewModelUnderTest.publication.value = dateFormatter.date(from: "10.12.2017")
        viewModelUnderTest.type.value = .class2
        
        let expiration = viewModelUnderTest.expirationString.value!
        
        XCTAssertEqual(expiration, "10.12.2018", "Expiration date is not correct.")
    }
    
    func testCountExpirationDateWithClass1Under40() {
        viewModelUnderTest.informations = PersonalInformations()
        viewModelUnderTest.informations!.birthDay = dateFormatter.date(from: "12.12.2017") // under 40
        viewModelUnderTest.publication.value = dateFormatter.date(from: "10.12.2017")
        viewModelUnderTest.type.value = .class1
        
        let expiration = viewModelUnderTest.expirationString.value!
        
        XCTAssertEqual(expiration, "10.12.2018", "Expiration date is not correct.")
    }
    
    func testCountExpirationDateWithClass1Over40() {
        viewModelUnderTest.informations = PersonalInformations()
        viewModelUnderTest.informations!.birthDay = dateFormatter.date(from: "12.12.1917") // under 40
        viewModelUnderTest.publication.value = dateFormatter.date(from: "10.12.2017")
        viewModelUnderTest.type.value = .class1
        
        let expiration = viewModelUnderTest.expirationString.value!
        
        XCTAssertEqual(expiration, "10.06.2018", "Expiration date is not correct.")
    }
    
}
