//
//  PlaneCell.swift
//  FlightRecords
//
//  Created by Martin Zid on 02/11/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//

import UIKit

/**
    PlaneCell is UITableCell, which is used for each of user's planes in PlanesTableView.
 */
class PlaneCell: UITableViewCell {

    /// UILabel that displays planes's registration No.
    @IBOutlet weak var registrationLabel: UILabel!
    /// UILabel that displays plane's type.
    @IBOutlet weak var typeLabel: UILabel!
    
    /// viewModel prepares data for each label of PlaneCell.
    var viewModel: PlaneViewModel! {
        didSet {
            registrationLabel.text = viewModel.getRegistrationNumber()
            typeLabel.text = viewModel.getType()
        }
    }
}
