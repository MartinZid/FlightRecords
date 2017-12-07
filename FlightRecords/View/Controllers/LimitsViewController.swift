//
//  LimitsViewController.swift
//  FlightRecords
//
//  Created by Martin Zid on 07/12/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift

class LimitsViewController: UITableViewController {

    @IBOutlet weak var hoursInDaysTitleLabel: UILabel!
    @IBOutlet weak var hoursInDaysLabel: UILabel!
    @IBOutlet weak var hoursInDaysProgress: UIProgressView!
    
    @IBOutlet weak var hoursInYearTitleLabel: UILabel!
    @IBOutlet weak var hoursInYearLabel: UILabel!
    @IBOutlet weak var hoursInYearProgress: UIProgressView!
    
    @IBOutlet weak var hoursInMonthsTitleLabel: UILabel!
    @IBOutlet weak var hoursInMonthsLabel: UILabel!
    @IBOutlet weak var hoursInMonthsProgress: UIProgressView!
    
    private let viewModel = LimitsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    private func bindViewModel() {
        hoursInDaysLabel.reactive.text <~ viewModel.inDaysLabel
        hoursInDaysTitleLabel.reactive.textColor <~ viewModel.inDays.map { (($0 > 100) ? UIColor.red : UIColor.black) }
        hoursInDaysProgress.reactive.progress <~ viewModel.inDays.map{ $0/100 }
        
        hoursInYearLabel.reactive.text <~ viewModel.inYearLabel
        hoursInYearTitleLabel.reactive.textColor <~ viewModel.inDays.map { (($0 > 900) ? UIColor.red : UIColor.black) }
        hoursInYearProgress.reactive.progress <~ viewModel.inYear.map{ $0/900 }
        
        hoursInMonthsLabel.reactive.text <~ viewModel.inMonthsLabel
        hoursInMonthsTitleLabel.reactive.textColor <~ viewModel.inDays.map { (($0 > 1000) ? UIColor.red : UIColor.black) }
        hoursInMonthsProgress.reactive.progress <~ viewModel.inMonths.map{ $0/1000 }
    }
}
