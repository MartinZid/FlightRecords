//
//  ProfileViewController.swift
//  FlightRecords
//
//  Created by Martin Zid on 18/03/2018.
//  Copyright © 2018 Martin Zid. All rights reserved.
//

import UIKit
import ToastSwiftFramework

class ProfileViewController: UITableViewController, PersonalInformationsControllerDelegate {
    
    private struct Identifiers {
        static let personalInformationsSegueIdentifier = "personalInformations"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func personalInformationSaved() {
        displaySavedToaster()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Identifiers.personalInformationsSegueIdentifier {
            if let personalInformationsVC = segue.destination.contentViewController as? PersonalInformationsViewController {
                personalInformationsVC.delegate = self
            }
        }
    }
}
