//
//  Extension.swift
//  FlightRecords
//
//  Created by Martin Zid on 19/10/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa
import ReactiveSwift

extension DateFormatter {
    struct Format{
        static let time = "HH:mm"
        static let date = "dd.MM.yyyy"
    }
    
    func dateToString(from date: Date) -> String {
        dateFormat = Format.date
        return string(from: date)
    }
    
    func timeToString(from date: Date) -> String {
        dateFormat = Format.time
        return string(from: date)
    }
    
    func createDate(hours: Int, minutes: Int) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        let now = Date()
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: now)
        components.hour = hours
        components.minute = minutes
        return calendar.date(from: components)!
    }
}

extension UIViewController {
    var contentViewController: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? self
        } else {
            return self
        }
    }
}

extension UITableViewController {
    internal func setEndEditingOnTap() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
}
