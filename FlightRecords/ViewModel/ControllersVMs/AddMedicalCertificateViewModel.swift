//
//  AddMedicalCertificateViewModel.swift
//  FlightRecords
//
//  Created by Martin Zid on 21/12/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//

import Foundation
import ReactiveSwift


class AddMedicalCertificateViewModel: RealmViewModel {
    
    private let dateFormatter = DateFormatter()
    
    var type: MutableProperty<MedicalCertificate.CertificateType>
    var typeString: MutableProperty<String>
    var name: MutableProperty<String?>
    var publication: MutableProperty<Date?>
    var publicationString = MutableProperty<String?>(nil)
    var expiration: MutableProperty<Date?>
    var expirationString = MutableProperty<String?>(nil)
    var description: MutableProperty<String?>
    
    private let types = [NSLocalizedString("LALP", comment: ""), NSLocalizedString("Class1", comment: ""), NSLocalizedString("Class2", comment: ""), NSLocalizedString("Custom", comment: "")]
    
    private let certificate: MedicalCertificate?
    let title: String
    
    init(with certificate: MedicalCertificate?) {
        self.certificate = certificate
        title = (certificate == nil ? NSLocalizedString("Add new certificate", comment: "") : NSLocalizedString("Edit certificate", comment: ""))
        type = MutableProperty(certificate?.type ?? .LALP)
        typeString = MutableProperty(types[type.value.rawValue])
        name = MutableProperty(certificate?.name ?? nil)
        publication = MutableProperty(certificate?.publicationDate ?? nil)
        expiration = MutableProperty(certificate?.expirationDate ?? nil)
        description = MutableProperty(certificate?.note ?? nil)
        
        super.init()
        
        type <~ typeString.producer.filterMap(type)
        publicationString <~ publication.producer.map(dateFormatter.optinalDateToString)
        //todo count expiration date after publication is set (according to certificate type and user's age)
        expirationString <~ expiration.producer.map(dateFormatter.optinalDateToString)
    }
    
    private func type(for value: String) -> MedicalCertificate.CertificateType {
        let index = types.index(where: {$0 == value})!
        let type = MedicalCertificate.CertificateType(rawValue: index)!
        return type
    }
    
    func getTypesCount() -> Int {
        return types.count
    }
    
    func getType(for row: Int) -> String {
        return types[row]
    }
    
    func saveCertificateToRealm() {
        let certificate = self.certificate ?? MedicalCertificate()
        try! realm.write {
            certificate.type = type.value
            certificate.name = name.value
            certificate.publicationDate = publication.value
            certificate.expirationDate = expiration.value
            certificate.note = description.value
            
            realm.add(certificate)
        }
    }
    
}
