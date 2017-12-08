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
    
    var searchConfiguration: SearchConfiguration?
    
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
        return SearchViewModel(with: searchConfiguration)
    }
    
    func apply(searchViewModel: SearchViewModel) {
        self.searchConfiguration = searchViewModel.getConfiguration()
        filterRecords()
    }
    
    private func filterRecords() {
        collection = realm.objects(Record.self)
        if let text = searchConfiguration?.searchText {
            if text.count > 0 {
                collection = collection?.filter("(from contains[c] %@) or (to contains[c] %@)", text, text)
            }
        }
        if searchConfiguration?.flightsSwitch == false {
            collection = collection?.filter("type == 1")
        }
        if searchConfiguration?.fstdSwitch == false {
            collection = collection?.filter("type == 0")
        }
        if let type = searchConfiguration?.planeType {
            if type.count > 0 {
                print(type)
                collection = collection?.filter("plane.type contains[c] %@", type)
            }
        }
        if let plane = searchConfiguration?.plane {
            collection = collection?.filter("plane == %@", plane)
        }
        if let fromDate = searchConfiguration?.fromDate {
            collection = collection?.filter("date > %@", Calendar.current.startOfDay(for: fromDate))
        }
        if let toDate = searchConfiguration?.toDate {
            collection = collection?.filter("date < %@", Calendar.current.startOfDay(for: toDate.addingTimeInterval(60 * 60 * 24)))
        }
        collectionNotificationsToken?.invalidate()
        collection = collection?.sorted(byKeyPath: "date", ascending: false)
        collectionNotificationsToken = collection?.observe(collectionChangedNotificationBlock)
    }
    
}



