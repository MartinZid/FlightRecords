//
//  RecordsViewModel.swift
//  FlightRecords
//
//  Created by Martin Zid on 12/10/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//

import Foundation
import RealmSwift
import ReactiveCocoa
import ReactiveSwift
import Result

/**
    RecordsViewModel is viewModel for RecordsTableViewController.
 */
class RecordsViewModel: RealmViewModel {
    
    /// List of all Records
    private var records = List<Record>()
    
    /**
     Creates new RecordsViewModel.
     */
    override init() {
        super.init()
    }
    
    /**
     This function updates Record's list with Records from Realm and notifies observers about it.
     */
    private func updateList() {
        if self.records.realm == nil {
            self.records.removeAll()
            self.records.append(objectsIn: self.realm.objects(Record.self))
        }
        contentChangedObserver.send(value: ())
    }
    
    /**
     This function is called, when Realm is intialized and calls updateList method.
     */
    override func realmInitCompleted() {
        updateList()
    }
    
    /**
     This function handles notifications from Realm. In this class it only calls updateList method.
     */
    override func notificationHandler(notification: Realm.Notification, realm: Realm) {
        print("new notification")
        updateList()
    }
    
    /**
     - Parameter indexPath: IndexPath which identifies which Record should be used for new RecordViewModel.
     - Returns: RecordViewModel intialized with Record at indexPath.
     */
    func getCellViewModel(for indexPath: IndexPath) -> RecordViewModel {
        return RecordViewModel(with: records[indexPath.row])
    }
    
    /**
     RecordsTableView has only one section.
     - Returns: 1
     */
    func numberOfSections() -> Int {
        return 1
    }
    
    /**
     This function return number of rows for RecordsTableView.
     - Returns: number of Records.
     */
    func numberOfRecordsInSection() -> Int {
        return records.count
    }
    
}
