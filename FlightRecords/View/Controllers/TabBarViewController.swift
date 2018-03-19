//
//  TabBarViewController.swift
//  FlightRecords
//
//  Created by Martin Zid on 19/03/2018.
//  Copyright © 2018 Martin Zid. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {

    private var shoudSelectIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        shoudSelectIndex = tabBarController.selectedIndex
        return true
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        // if user tapped the same index as before, pop to root view controller as expected
        if shoudSelectIndex == tabBarController.selectedIndex {
            if let splitViewController = viewController as? UISplitViewController {
                if let navController = splitViewController.viewControllers[0] as? UINavigationController {
                    navController.popToRootViewController(animated: true)
                }
            }
        }
    }

}
