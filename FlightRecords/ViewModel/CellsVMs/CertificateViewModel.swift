//
//  CertificateViewModel.swift
//  FlightRecords
//
//  Created by Martin Zid on 08/12/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//

import Foundation

/**
 CertificateViewModel prepares data for CertificateCell.
 */
class CertificateViewModel {
    
    private let certificate: MedicalCertificate
    
    // MARK: - Initialization
    
    init(with certificate: MedicalCertificate) {
        self.certificate = certificate
    }
    
    // MARK: - API
    
    func getCertificateName() -> String {
        return certificate.name ?? NSLocalizedString("Without name", comment: "")
    }
    
    /**
     This function returns certificate expiration date in string format if one is set. If not it
     returns localized N/A.
    */
    func getCertificateExpiration() -> String {
        let dateformatter = DateFormatter()
        
        if let date = certificate.expirationDate {
            let dateString = dateformatter.dateToString(from: date)
            return dateString
        }
        return NSLocalizedString("N/A", comment: "")
    }
}
