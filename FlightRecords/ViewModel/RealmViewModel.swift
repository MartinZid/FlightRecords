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

class RealmViewModel {
    
    internal var notificationToken: NotificationToken!
    internal var realm: Realm!
    let contentChangedSignal: Signal<Void, NoError>
    internal let contentChangedObserver: Signal<Void, NoError>.Observer
    
    init() {
        let (contentChangedSignal, contentChangedObserver) = Signal<Void, NoError>.pipe()
        self.contentChangedSignal = contentChangedSignal
        self.contentChangedObserver = contentChangedObserver
        
        let username = "TestUser"
        let password = "test"
        let url = "http://127.0.0.1:9080"
        //let url = "http://192.168.1.100:9080"
        SyncUser.logIn(with: .usernamePassword(username: username, password: password, register: false),
                       server: URL(string: url)!) { user, error in
            guard let user = user else {
                fatalError(String(describing: error))
            }
            DispatchQueue.main.async {
                print("preparing Realm...")
                let configuration = Realm.Configuration(
                    syncConfiguration: SyncConfiguration(user: user, realmURL: URL(string: "realm://127.0.0.1:9080/~/testrecords03")!)
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
    
    deinit {
        notificationToken.invalidate()
    }
}
