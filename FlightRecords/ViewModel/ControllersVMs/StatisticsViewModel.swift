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
        //recordsNotificationsToken = records?.observe(countStatistics)
        countStatistics()
    }
    
    override func realmInitCompleted() {
        updateList()
    }
    
    override func notificationHandler(notification: Realm.Notification, realm: Realm) {
        countStatistics()
    }
    
    private func countStatistics(/*changes: RealmCollectionChange<Results<Record>>*/) {
        if let records = records {
            totalTimeString.value = countTime(from: records.map{ dateFormatter.createTime(from: $0.time!) })
            nightTimeString.value = countTime(from: records.map{ $0.timeNight } )
            ifrTimeString.value = countTime(from: records.map{ $0.timeIFR } )
            picTimeString.value = countTime(from: records.map{ $0.timePIC } )
            coTimeString.value = countTime(from: records.map{ $0.timeCO } )
            dualTimeString.value = countTime(from: records.map{ $0.timeDUAL } )
            instructorTimeString.value = countTime(from: records.map{ $0.timeInstructor } )
        }
    }
    
    private func countTime(from array: [Date?]) -> String {
        var hours = 0
        var minutes = 0
        for elem in array {
            if let time = elem {
                let components = dateFormatter.getDateComponents(from: time)
                hours += components.hour!
                minutes += components.minute!
            }
        }
        hours += minutes/60
        minutes = minutes % 60
        return String(hours) + ":" + String(format: "%02d", minutes)
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
    }
}
