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

/**
 Base ViewModel for all ViewModels associated with dynamic UITableViewControllers, which display data from the Realm (records, planes, etc.)
 */
class RealmTableViewModel<T: Object>: RealmViewModel {
    
    internal var collection: Results<T>?
    internal var deletedObject: T?
    
    var collectionNotificationsToken: NotificationToken? = nil
    
    /// Signal informing about all types of changes (add, delete, update, etc.) in given collection
    let collectionChangedSignal: Signal<RealmCollectionChange<Results<T>>, NoError>
    private let collectionChangedObserver: Signal<RealmCollectionChange<Results<T>>, NoError>.Observer
    
    // MARK: - Initialization
    
    override init() {
        let (arrayChangedSignal, arrayChangedObserver) = Signal<RealmCollectionChange<Results<T>>, NoError>.pipe()
        self.collectionChangedSignal = arrayChangedSignal
        self.collectionChangedObserver = arrayChangedObserver
        super.init()
    }
    
    deinit {
        collectionNotificationsToken?.invalidate()
    }
    
    // MARK: - API
    
    internal func updateList() {
        collection = realm.objects(T.self)
        collectionNotificationsToken = collection?.observe(collectionChangedNotificationBlock)
    }
    
    internal func collectionChangedNotificationBlock(changes: RealmCollectionChange<Results<T>>) {
        collectionChangedObserver.send(value: changes)
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
    
    func undoDelete() {
        if let deletedObject = deletedObject {
            try! realm.write {
                realm.add(deletedObject)
            }
        }
        deletedObject = nil
    }
    
}






