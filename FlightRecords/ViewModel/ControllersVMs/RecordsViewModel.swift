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

class RecordsViewModel: RealmTableViewModel<Record> {
    
    private let filter = Filter()
    
    override func updateList() {
        collection = realm.objects(Record.self)
        collection = collection?.sorted(byKeyPath: "date", ascending: false)
        collectionNotificationsToken = collection?.observe(collectionChangedNotificationBlock)
    }
    
    func getCellViewModel(for indexPath: IndexPath) -> RecordViewModel {
        return RecordViewModel(with: collection![indexPath.row])
    }
    
    func numberOfRecordsInSection() -> Int {
        return super.numberOfObjectsInSection()
    }
    
    func deleteRecord(at indexPath: IndexPath) {
        deleteObject(at: indexPath)
    }
    
    func getTypeOfRecord(at indexPath: IndexPath) -> Record.RecordType {
        return collection![indexPath.row].type
    }
    
    func getAddFlightViewModel(for indexPath: IndexPath) -> AddFlightRecordViewModel {
        let record = collection![indexPath.row]
        return AddFlightRecordViewModel(with: record)
    }
    
    func getAddSimulatorViewModel(for indexPath: IndexPath) -> AddSimulatorRecordViewModel {
        let record = collection![indexPath.row]
        return AddSimulatorRecordViewModel(with: record)
    }
    
    func getSearchViewModel() -> SearchViewModel {
        return SearchViewModel(with: filter.searchConfiguration)
    }
    
    func apply(searchViewModel: SearchViewModel) {
        filter.searchConfiguration = searchViewModel.getConfiguration()
        filterRecords()
    }
    
    private func filterRecords() {
        collection = filter.filterRecords(from: realm.objects(Record.self))
        collectionNotificationsToken?.invalidate()
        collection = collection?.sorted(byKeyPath: "date", ascending: false)
        collectionNotificationsToken = collection?.observe(collectionChangedNotificationBlock)
    }
    
}



