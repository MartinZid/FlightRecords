//
//  UIViewControllerExtension.swift
//  FlightRecords
//
//  Created by Martin Zid on 30/11/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//
import UIKit

extension UIViewController {
    var contentViewController: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? self
        } else {
            return self
        }
    }
    
    func confirmDeleteAction(_ action: @escaping ((UIAlertAction) -> Void)) {
        let alert = UIAlertController(
            title: NSLocalizedString("Delete confirm", comment: ""),
            message: NSLocalizedString("Delete record confirm message", comment: ""),
            preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Delete", comment: ""), style: UIAlertActionStyle.default, handler: action))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertActionStyle.cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}
