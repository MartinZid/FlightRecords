//
//  RealmHandler.swift
//  FlightRecords
//
//  Created by Martin Zid on 12/10/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//

import Foundation
import RealmSwift
import ReactiveSwift
import Result

/**
    RealmViewModel handles all activity asociated with Realm.
 */
class RealmViewModel {
    /// notificationToken is Realm's object which is notified everytime Realm is changed.
    internal var notificationToken: NotificationToken!
    /// realm is a instance of Realm class
    internal var realm: Realm!
    /// This variable can be observed for notifications about change in records list.
    let contentChangedSignal: Signal<Void, NoError>
    /// To contentChangedObserver is send a value, everytime records list is updated.
    internal let contentChangedObserver: Signal<Void, NoError>.Observer
    
    /**
     Init function sets up Realm instance, logins user to Realm, sets up notifications and informs when all is set.
     */
    init() {
        let (contentChangedSignal, contentChangedObserver) = Signal<Void, NoError>.pipe()
        self.contentChangedSignal = contentChangedSignal
        self.contentChangedObserver = contentChangedObserver
        
        let username = "TestUser"
        let password = "test"
        SyncUser.logIn(with: .usernamePassword(username: username, password: password, register: false), server: URL(string: "http://127.0.0.1:9080")!) { user, error in
            guard let user = user else {
                fatalError(String(describing: error))
            }
            DispatchQueue.main.async {
                print("preparing Realm...")
                let configuration = Realm.Configuration(
                    syncConfiguration: SyncConfiguration(user: user, realmURL: URL(string: "realm://127.0.0.1:9080/~/testrecords")!)
                )
                self.realm = try! Realm(configuration: configuration)
                
                print("Realm instance set up")
                
                self.notificationToken = self.realm.observe(self.notificationHandler)
                self.realmInitCompleted()
            }
        }
    }
    
    /**
     Abstract function which is called after Realm instance is set.
     */
    internal func realmInitCompleted() {}
    
    /**
     Abstract function which handles Realm's notifications.
     - Parameter notification: Instance of Realm.Notification, which is passed by Realm itself.
     - Parameter realm: Instance of Realm.
     */
    internal func notificationHandler(notification: Realm.Notification, realm: Realm) {}
    
    /**
     This function is a destructor, which stop Realm's notifications.
     */
    deinit {
        notificationToken.invalidate()
    }
}
