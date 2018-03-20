//
//  TabBarViewController.swift
//  FlightRecords
//
//  Created by Martin Zid on 19/03/2018.
//  Copyright © 2018 Martin Zid. All rights reserved.
//

import UIKit

/**
 UITabBarController which extends tab bar actions to behave as expected with UISplitViewController.
 */
class TabBarViewController: UITabBarController, UITabBarControllerDelegate {

    private var shouldSelectIndex = -1
    
    // MARK: - Controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    // MARK: - UITabBarControllerDelegate
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        shouldSelectIndex = tabBarController.selectedIndex
        return true
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        // if user tapped the same index as before, pop to root view controller as expected
        if shouldSelectIndex == tabBarController.selectedIndex {
            if let splitViewController = viewController as? UISplitViewController {
                if let navController = splitViewController.viewControllers[0] as? UINavigationController {
                    navController.popToRootViewController(animated: true)
                }
            }
        }
    }
}
