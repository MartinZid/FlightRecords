//
//  CertificateViewCell.swift
//  FlightRecords
//
//  Created by Martin Zid on 08/12/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//

import UIKit

class CertificateViewCell: UITableViewCell {

    @IBOutlet weak var certificateNameLabel: UILabel!
    @IBOutlet weak var expirationDateLabel: UILabel!
    
    var viewModel: CertificateViewModel! {
        didSet {
            certificateNameLabel.text = viewModel.getCertificateName()
            expirationDateLabel.text = viewModel.getCertificateExpiration()
        }
    }
    
}
