//
//  ProfileViewController.swift
//  FlightRecords
//
//  Created by Martin Zid on 18/03/2018.
//  Copyright © 2018 Martin Zid. All rights reserved.
//

import UIKit
import ToastSwiftFramework

/**
 Profile tab root ViewController.
 */
class ProfileViewController: UITableViewController, PersonalInformationsControllerDelegate {
    
    private struct Identifiers {
        static let personalInformationsSegueIdentifier = "personalInformations"
    }
    
    // MARK: - Controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - PersonalInformationsControllerDelegate
    
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
