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
    
    override init() {
        super.init()
    }
    
    private func updateList() {
        if self.records.realm == nil {
            self.records.removeAll()
            self.records.append(objectsIn: self.realm.objects(Record.self))
        }
        contentChangedObserver.send(value: ())
    }
    
    override func realmInitCompleted() {
        updateList()
    }
    
    override func notificationHandler(notification: Realm.Notification, realm: Realm) {
        print("new notification")
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



