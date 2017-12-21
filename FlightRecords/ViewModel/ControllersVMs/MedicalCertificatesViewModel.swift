//
//  MedicalCertificatesViewModel.swift
//  FlightRecords
//
//  Created by Martin Zid on 08/12/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//

import Foundation
import RealmSwift
import ReactiveCocoa
import ReactiveSwift
import Result

class MedicalCertificatesViewModel: RealmTableViewModel<MedicalCertificate> {
    
    func getCellViewModel(for indexPath: IndexPath) -> CertificateViewModel {
        return CertificateViewModel(with: collection![indexPath.row])
    }
    
    func numberOfCertificatesInSection() -> Int {
        return numberOfObjectsInSection()
    }
    
    func deleteCertificate(at indexPath: IndexPath) {
        deleteObject(at: indexPath)
    }
    
    func getAddCertificateViewModel(for indexPath: IndexPath) -> AddMedicalCertificateViewModel {
        return AddMedicalCertificateViewModel(with: collection![indexPath.row])
    }
    
}
