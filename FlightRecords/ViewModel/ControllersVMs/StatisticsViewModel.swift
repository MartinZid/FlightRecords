//
//  StatisticsViewModel.swift
//  FlightRecords
//
//  Created by Martin Zid on 22/01/2018.
//  Copyright © 2018 Martin Zid. All rights reserved.
//

import Foundation
import RealmSwift
import ReactiveSwift

class StatisticsViewModel: RealmViewModel {
    
    let totalTimeString = MutableProperty<String>("0:00")
    let nightTimeString = MutableProperty<String>("0:00")
    let ifrTimeString = MutableProperty<String>("0:00")
    let picTimeString = MutableProperty<String>("0:00")
    let coTimeString = MutableProperty<String>("0:00")
    let dualTimeString = MutableProperty<String>("0:00")
    let instructorTimeString = MutableProperty<String>("0:00")
    
    private let dateFormatter = DateFormatter()
    
    private let filter = Filter()
    private var records: Results<Record>?
    var recordsNotificationsToken: NotificationToken? = nil
    
    override init() {
        
    }
    
    private func updateList() {
        records = realm.objects(Record.self)
        recordsNotificationsToken = records?.observe { [weak self] _ in
            self?.countStatistics()
        }
        countStatistics()
    }
    
    override func realmInitCompleted() {
        updateList()
    }
    
    override func notificationHandler(notification: Realm.Notification, realm: Realm) {
        countStatistics()
    }
    
    private func countStatistics() {
        if let records = records {
            totalTimeString.value = dateFormatter.countTime(from: records.map{ dateFormatter.createTime(from: $0.time!) })
            nightTimeString.value = dateFormatter.countTime(from: records.map{ $0.timeNight } )
            ifrTimeString.value = dateFormatter.countTime(from: records.map{ $0.timeIFR } )
            picTimeString.value = dateFormatter.countTime(from: records.map{ $0.timePIC } )
            coTimeString.value = dateFormatter.countTime(from: records.map{ $0.timeCO } )
            dualTimeString.value = dateFormatter.countTime(from: records.map{ $0.timeDUAL } )
            instructorTimeString.value = dateFormatter.countTime(from: records.map{ $0.timeInstructor } )
        }
    }
    
    deinit {
        recordsNotificationsToken?.invalidate()
    }
    
    func getSearchViewModel() -> SearchViewModel {
        return SearchViewModel(with: filter.searchConfiguration)
    }
    
    func apply(searchViewModel: SearchViewModel) {
        filter.searchConfiguration = searchViewModel.getConfiguration()
        filterRecords()
    }
    
    private func filterRecords() {
        records = filter.filterRecords(from: realm.objects(Record.self))
        recordsNotificationsToken?.invalidate()
        recordsNotificationsToken = records?.observe{ [weak self] _ in
            self?.countStatistics()
        }
    }
}
