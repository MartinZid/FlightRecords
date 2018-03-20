//
//  SplitViewController.swift
//  FlightRecords
//
//  Created by Martin Zid on 31/01/2018.
//  Copyright © 2018 Martin Zid. All rights reserved.
//

import UIKit

/**
 UISplitViewController class containg default configuration for all UISplitViewController (this class should be asigned to all UISplitViewController in storyboards).
 */
class SplitViewController: UISplitViewController, UISplitViewControllerDelegate {
    
    // MARK: - Controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredDisplayMode = .allVisible
        delegate = self
    }
    
    // MARK: - UISplitViewControllerDelegate
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
        return true
    }

}
