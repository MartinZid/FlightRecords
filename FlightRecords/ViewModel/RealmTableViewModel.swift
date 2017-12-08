//
//  RealmTableViewModel.swift
//  FlightRecords
//
//  Created by Martin Zid on 08/12/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//

import Foundation
import RealmSwift
import ReactiveCocoa
import ReactiveSwift
import Result

class RealmTableViewModel<T: Object>: RealmViewModel {
    
    internal var collection: Results<T>?
    
    var collectionNotificationsToken: NotificationToken? = nil
    let collectionChangedSignal: Signal<RealmCollectionChange<Results<T>>, NoError>
    private let collectionChangedObserver: Signal<RealmCollectionChange<Results<T>>, NoError>.Observer
    
    override init() {
        let (arrayChangedSignal, arrayChangedObserver) = Signal<RealmCollectionChange<Results<T>>, NoError>.pipe()
        self.collectionChangedSignal = arrayChangedSignal
        self.collectionChangedObserver = arrayChangedObserver
        super.init()
    }
    
    internal func updateList() {
        collection = realm.objects(T.self)
        collectionNotificationsToken = collection?.observe(collectionChangedNotificationBlock)
    }
    
    internal func collectionChangedNotificationBlock(changes: RealmCollectionChange<Results<T>>) {
        collectionChangedObserver.send(value: changes)
    }
    
    deinit {
        collectionNotificationsToken?.invalidate()
    }
    
    override func realmInitCompleted() {
        updateList()
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    internal func numberOfObjectsInSection() -> Int {
        if let list = collection {
            return list.count
        }
        return 0
    }

    internal func deleteObject(at indexPath: IndexPath) {
        try! realm.write {
            realm.delete(collection![indexPath.row])
        }
    }
    
}






