//
//  RecordViewCell.swift
//  FlightRecords
//
//  Created by Martin Zid on 12/10/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//

import UIKit

/**
     RecordCell is UITableCell, which is used for each record in RecordsTableView.
 */
class RecordCell: UITableViewCell {
    
    /// Date label displays record's date
    @IBOutlet weak var date: UILabel!
    /// Destination label displays record's destination
    @IBOutlet weak var destination: UILabel!
    /// Time label displays record's total flight time
    @IBOutlet weak var time: UILabel!
    /// RegistrationNumber label displays plane's registration number
    @IBOutlet weak var registrationNumber: UILabel!
    
    /// viewModel prepares data (date, destinations, time and reg. no.) for each label of RecordCell.
    var viewModel: RecordViewModel! {
        didSet {
            date.text = viewModel.getDate()
            destination.text = viewModel.getDestinations()
            time.text = viewModel.getTime()
            registrationNumber.text = viewModel.getPlane()?.registrationNumber ?? NSLocalizedString("N/A", comment: "")
        }
    }
}
