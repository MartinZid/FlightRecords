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
 Flight and simulator records ViewModel.
 */
class RecordsViewModel: RealmTableViewModel<Record> {
    
    /// Signal informing about every change in the search configuration
    let searchConfigurationChangedSignal: Signal<Bool, NoError>
    private let searchConfigurationChangedObserver: Signal<Bool, NoError>.Observer
    
    private let filter = Filter()
    
    // MARK: - Initialization
    
    override init() {
        let (searchConfigurationChangedSignal, searchConfigurationChangedObserver) = Signal<Bool, NoError>.pipe()
        self.searchConfigurationChangedSignal = searchConfigurationChangedSignal
        self.searchConfigurationChangedObserver = searchConfigurationChangedObserver
        super.init()
    }
    
    // MARK: - Helpers
    
    private func hasDefaulFilter() -> Bool {
        if let searchConfiguration = filter.searchConfiguration {
            return searchConfiguration.isDefaul()
        }
        return true
    }
    
    private func filterRecords() {
        searchConfigurationChangedObserver.send(value: hasDefaulFilter())
        
        collection = filter.filterRecords(from: realm.objects(Record.self))
        collectionNotificationsToken?.invalidate()
        collection = collection?.sorted(byKeyPath: "date", ascending: false)
        collectionNotificationsToken = collection?.observe(collectionChangedNotificationBlock)
    }
    
    override func updateList() {
        collection = realm.objects(Record.self)
        collection = collection?.sorted(byKeyPath: "date", ascending: false)
        collectionNotificationsToken = collection?.observe(collectionChangedNotificationBlock)
    }
    
    // MARK: - API
    
    func getCellViewModel(for indexPath: IndexPath) -> RecordViewModel {
        return RecordViewModel(with: collection![indexPath.row])
    }
    
    func numberOfRecordsInSection() -> Int {
        return super.numberOfObjectsInSection()
    }
    
    func deleteRecord(at indexPath: IndexPath) {
        deletedObject = Record(value: collection![indexPath.row])
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
    
    func getPDFGeneratorViewModel() -> PDFGeneratorViewModel {
        return PDFGeneratorViewModel(with: collection)
    }
    
    func apply(searchViewModel: SearchViewModel) {
        filter.searchConfiguration = searchViewModel.getConfiguration()
        filterRecords()
    }
    
    func disableFilters() {
        filter.searchConfiguration = SearchConfiguration()
        filterRecords()
    }
}



