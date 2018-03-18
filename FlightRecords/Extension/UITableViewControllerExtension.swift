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
import ToastSwiftFramework

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
                if insertions.count > 0 || modifications.count > 0 {
                    self?.displaySavedToaster()
                }
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
    
    internal func displayEmptyTableMessage(message: String, subMessage: String) {
        let rect = CGRect(origin: CGPoint(x: 0,y :0), size:
            CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        let messageLabel = UILabel(frame: rect)
        messageLabel.text = message + "\n" + subMessage
        messageLabel.textColor = UIColor.black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.sizeToFit()
        
        self.tableView.backgroundView = messageLabel;
        self.tableView.separatorStyle = .none;
    }
    
    internal func deleteEmptyTableMessage() {
        self.tableView.backgroundView = nil
        self.tableView.separatorStyle = .singleLine
    }
}
