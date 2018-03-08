//
//  CertificateViewModel.swift
//  FlightRecords
//
//  Created by Martin Zid on 08/12/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//

import Foundation

class CertificateViewModel {
    
    private let certificate: MedicalCertificate
    
    init(with certificate: MedicalCertificate) {
        self.certificate = certificate
    }
    
    func getCertificateName() -> String {
        return certificate.name ?? NSLocalizedString("Without name", comment: "")
    }
    
    func getCertificateExpiration() -> String {
        let dateformatter = DateFormatter()
        
        if let date = certificate.expirationDate {
            let dateString = dateformatter.dateToString(from: date)
            return dateString
        }
        return NSLocalizedString("N/A", comment: "")
    }
    
}
