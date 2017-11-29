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
    
    private var records: Results<Record>?
    
    var recordsNotificationsToken: NotificationToken? = nil
    let recordsChangedSignal: Signal<RealmCollectionChange<Results<Record>>, NoError>
    private let recordsChangedObserver: Signal<RealmCollectionChange<Results<Record>>, NoError>.Observer
    
    var searchConfiguration: SearchConfiguration?
    
    override init() {
        let (recordsChangedSignal, recordsChangedObserver) = Signal<RealmCollectionChange<Results<Record>>, NoError>.pipe()
        self.recordsChangedSignal = recordsChangedSignal
        self.recordsChangedObserver = recordsChangedObserver
        super.init()
    }
    
    private func updateList() {
        records = realm.objects(Record.self)
        recordsNotificationsToken = records?.observe{ [weak self] (changes: RealmCollectionChange<Results<Record>>) in
            self?.recordsChangedObserver.send(value: changes)
        }
    }
    
    deinit {
        recordsNotificationsToken?.invalidate()
    }
    
    override func realmInitCompleted() {
        updateList()
    }
    
    func getCellViewModel(for indexPath: IndexPath) -> RecordViewModel {
        return RecordViewModel(with: records![indexPath.row])
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRecordsInSection() -> Int {
        if let list = records {
            return list.count
        }
        return 0
    }
    
    func deleteRecord(at indexPath: IndexPath) {
        try! realm.write {
            realm.delete(records![indexPath.row])
        }
    }
    
    func getTypeOfRecord(at indexPath: IndexPath) -> Record.RecordType {
        return records![indexPath.row].type
    }
    
    func getAddFlightViewModel(for indexPath: IndexPath) -> AddFlightRecordViewModel {
        let record = records![indexPath.row]
        return AddFlightRecordViewModel(with: record)
    }
    
    func getAddSimulatorViewModel(for indexPath: IndexPath) -> AddSimulatorRecordViewModel {
        let record = records![indexPath.row]
        return AddSimulatorRecordViewModel(with: record)
    }
    
    func getSearchViewModel() -> SearchViewModel {
        return SearchViewModel(with: searchConfiguration)
    }
    
    func apply(searchViewModel: SearchViewModel) {
        self.searchConfiguration = searchViewModel.getConfiguration()
        filterRecords()
    }
    
    private func filterRecords() {
        records = realm.objects(Record.self)
        if let text = searchConfiguration?.searchText {
            if text.count > 0 {
                records = records?.filter("(from contains[c] %@) or (to contains[c] %@)", text, text)
            }
        }
        if searchConfiguration?.flightsSwitch == false {
            records = records?.filter("type == 1")
        }
        if searchConfiguration?.fstdSwitch == false {
            records = records?.filter("type == 0")
        }
        if let type = searchConfiguration?.planeType {
            if type.count > 0 {
                print(type)
                records = records?.filter("plane.type contains[c] %@", type)
            }
        }
        if let plane = searchConfiguration?.plane {
            records = records?.filter("plane == %@", plane)
        }
        if let fromDate = searchConfiguration?.fromDate {
            records = records?.filter("date >= %@", fromDate)
        }
        if let toDate = searchConfiguration?.toDate {
            records = records?.filter("date <= %@", toDate)
        }
    }
    
}



