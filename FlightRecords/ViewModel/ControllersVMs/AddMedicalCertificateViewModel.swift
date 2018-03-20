//
//  AddMedicalCertificateViewModel.swift
//  FlightRecords
//
//  Created by Martin Zid on 21/12/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//

import Foundation
import ReactiveSwift

/**
 Add/update medical certificate ViewModel.
 */
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
    var informations: PersonalInformations?
    
    /// String containing view's title
    let title: String
    
    // MARK: - Initialization
    
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
        
        expiration <~ Signal.combineLatest(publication.signal, type.signal).map(countExpirationDate)
        type <~ typeString.producer.filterMap(type)
        publicationString <~ publication.producer.map(dateFormatter.optinalDateToString)
        expirationString <~ expiration.producer.map(dateFormatter.optinalDateToString)
    }
    
    // MARK: - Helpers
    
    override func realmInitCompleted() {
        informations = realm.objects(PersonalInformations.self).first
    }
    
    private func type(for value: String) -> MedicalCertificate.CertificateType {
        let index = types.index(where: {$0 == value})!
        let type = MedicalCertificate.CertificateType(rawValue: index)!
        return type
    }
    
    /**
     This function counts expiration date of given certificate type according to Part.MED.
     - parameters:
        - publicationDate: certificate publication date
        - type: certificate type
     - returns: certificate expiration date
     */
    private func countExpirationDate(from publicationDate: Date?, with type: MedicalCertificate.CertificateType) -> Date? {
        if let publication = publicationDate {
            if let informations = informations {
                let age = informations.getAge()
                switch type {
                case .LALP:
                    if age < 40 {
                        return dateFormatter.add(years: 5, to: publication)
                    }
                    return dateFormatter.add(years: 2, to: publication)
                case .class2:
                    if age < 40 {
                        return dateFormatter.add(years: 5, to: publication)
                    } else if age < 50 {
                        return dateFormatter.add(years: 2, to: publication)
                    }
                    return dateFormatter.add(years: 1, to: publication)
                case .class1:
                    if age < 40 {
                        return dateFormatter.add(years: 1, to: publication)
                    }
                    return dateFormatter.add(months: 6, to: publication)
                case .custom:
                    return nil
                }
            }
        }
        return nil
    }
    
    // MARK: - API
    
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
