//
//  MedicalCertificate.swift
//  FlightRecords
//
//  Created by Martin Zid on 08/12/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//

import Foundation
import RealmSwift

final class MedicalCertificate: Object {
    @objc dynamic var type: CertificateType = .LALP
    @objc dynamic var name: String? = nil
    @objc dynamic var publicationDate: Date? = nil
    @objc dynamic var expirationDate: Date? = nil
    @objc dynamic var note: String? = nil
    
    @objc enum CertificateType: Int {
        case LALP
        case class1
        case class2
        case custom
    }
}
