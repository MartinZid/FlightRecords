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

class RecordsViewModel: RealmHandler {
    
    /// This variable can be observed for notifications about change in records list.
    let contentChangedSignal: Signal<Void, NoError>
    /// To *contentChangedObserver* is send a value, everytime records list is updated.
    private let contentChangedObserver: Signal<Void, NoError>.Observer
    /// List of all *Record*s
    private var records = List<Record>()
    
    /**
     Initialize all class variables.
     */
    override init() {
        let (contentChangedSignal, contentChangedObserver) = Signal<Void, NoError>.pipe()
        self.contentChangedSignal = contentChangedSignal
        self.contentChangedObserver = contentChangedObserver
        super.init()
    }
    
    /**
     This function is called, when *Realm* is intialized. It gets all *Record*s from *Realm* and notifies observers about it.
     */
    override func realmInitCompleted() {
        if self.records.realm == nil {
            self.records.append(objectsIn: self.realm.objects(Record.self))
        }
        contentChangedObserver.send(value: ())
    }
    
    /**
     - Parameter indexPath: IndexPath which identifies which *Record* should be used for new *RecordViewModel*.
     - Returns: *RecordViewModel* intialized with *Record* at *indexPath*.
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
     - Returns: number of *Records*.
     */
    func numberOfRecordsInSection() -> Int {
        return records.count
    }
    
}
