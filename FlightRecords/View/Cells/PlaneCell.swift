//
//  PlaneCell.swift
//  FlightRecords
//
//  Created by Martin Zid on 02/11/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//

import UIKit

/**
 Plane UITableViewCell.
 */
class PlaneCell: UITableViewCell {

    @IBOutlet weak var registrationLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    var viewModel: PlaneViewModel! {
        didSet {
            registrationLabel.text = viewModel.getRegistrationNumber()
            typeLabel.text = viewModel.getPlaneInfo()
        }
    }
}
