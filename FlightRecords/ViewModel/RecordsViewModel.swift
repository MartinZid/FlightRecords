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

class RecordsViewModel: RealmViewModel {
    
    private var records = List<Record>()
//    var recordNotifications: NotificationToken? = nil
//
//    let recordsChangedSignal: Signal<RealmCollectionChange<List<Record>>, NoError>
//    private let recordsChangedObserver: Signal<RealmCollectionChange<List<Record>>, NoError>.Observer
    
    override init() {
//        let (recordsChangedSignal, recordsChangedObserver) = Signal<RealmCollectionChange<List<Record>>, NoError>.pipe()
//        self.recordsChangedSignal = recordsChangedSignal
//        self.recordsChangedObserver = recordsChangedObserver
        super.init()
    }
    
    private func updateList() {
        if self.records.realm == nil {
            self.records.removeAll()
            self.records.append(objectsIn: self.realm.objects(Record.self))
        }
        contentChangedObserver.send(value: ())
//        records = realm.objects(Record.self)
//        recordNotifications = records.observe{ [weak self] (changes: RealmCollectionChange<List<Record>>) in
//            self?.recordsChangedObserver.send(value: changes)
//        }
    }
    
//    deinit {
//        recordNotifications?.invalidate()
//    }
    
    override func realmInitCompleted() {
        updateList()
    }
    
    override func notificationHandler(notification: Realm.Notification, realm: Realm) {
        updateList()
    }
    
    func getCellViewModel(for indexPath: IndexPath) -> RecordViewModel {
        return RecordViewModel(with: records[indexPath.row])
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRecordsInSection() -> Int {
        return records.count
    }
    
    func deleteRecord(at indexPath: IndexPath) {
//        realm.beginWrite()
//        realm.delete(records[indexPath.row])
//        try! realm.commitWrite(withoutNotifying: [notificationToken])
        try! realm.write {
            realm.delete(records[indexPath.row])
        }
    }
    
    func getTypeOfRecord(at indexPath: IndexPath) -> Record.RecordType {
        return records[indexPath.row].type
    }
    
    func getAddFlightViewModel(for indexPath: IndexPath) -> AddFlightRecordViewModel {
        let record = records[indexPath.row]
        return AddFlightRecordViewModel(with: record)
    }
    
    func getAddSimulatorViewModel(for indexPath: IndexPath) -> AddSimulatorRecordViewModel {
        let record = records[indexPath.row]
        return AddSimulatorRecordViewModel(with: record)
    }
    
}



