//
//  Extension.swift
//  FlightRecords
//
//  Created by Martin Zid on 19/10/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//
import UIKit
import ReactiveSwift
import Result
import RealmSwift

extension UITableViewController {
    internal func setEndEditingOnTap() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    internal func observeSignalForTableDataChanges<T>(with signal: Signal<RealmCollectionChange<Results<T>>, NoError>) {
        signal.observeValues{ [weak self] changes in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                     with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.endUpdates()
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
}
