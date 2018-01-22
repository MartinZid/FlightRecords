//
//  StatisticsViewController.swift
//  FlightRecords
//
//  Created by Martin Zid on 22/01/2018.
//  Copyright © 2018 Martin Zid. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift

class StatisticsViewController: UITableViewController, SearchViewControllerDelegate {
    
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var nightTimeLabel: UILabel!
    @IBOutlet weak var ifrTimeLabel: UILabel!
    @IBOutlet weak var picTimeLabel: UILabel!
    @IBOutlet weak var coTimeLabel: UILabel!
    @IBOutlet weak var dualTimeLabel: UILabel!
    @IBOutlet weak var instructorTimeLabel: UILabel!
    
    private let viewModel = StatisticsViewModel()
    
    private struct Identifiers {
        static let searchSegueIdentifier = "search"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    private func bindViewModel() {
        totalTimeLabel.reactive.text <~ viewModel.totalTimeString
        nightTimeLabel.reactive.text <~ viewModel.nightTimeString
        ifrTimeLabel.reactive.text <~ viewModel.ifrTimeString
        picTimeLabel.reactive.text <~ viewModel.picTimeString
        coTimeLabel.reactive.text <~ viewModel.coTimeString
        dualTimeLabel.reactive.text <~ viewModel.dualTimeString
        instructorTimeLabel.reactive.text <~ viewModel.instructorTimeString
    }
    
    // MARK: - Delegation
    
    func apply(searchViewModel viewModel: SearchViewModel) {
        self.viewModel.apply(searchViewModel: viewModel)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Identifiers.searchSegueIdentifier {
            if let searchVC = segue.destination.contentViewController as? SearchViewController {
                searchVC.delegate = self
                searchVC.viewModel = viewModel.getSearchViewModel()
            }
        }
    }
}
