//
//  RecordViewCell.swift
//  FlightRecords
//
//  Created by Martin Zid on 12/10/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//

import UIKit

class RecordCell: UITableViewCell {
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var destination: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var registrationNumber: UILabel!
    
    var viewModel: RecordViewModel! {
        didSet {
            date.text = viewModel.getDate()
            destination.text = viewModel.getDestinations()
            time.text = viewModel.getTime()
            registrationNumber.text = viewModel.getRegistrationNumber()
        }
    }
}
