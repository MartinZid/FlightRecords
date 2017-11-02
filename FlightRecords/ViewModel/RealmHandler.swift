//
//  RealmHandler.swift
//  FlightRecords
//
//  Created by Martin Zid on 12/10/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//

import Foundation
import RealmSwift

class RealmHandler {
    /// notificationToken is *Realm*'s object which is notified everytime Realm is changed.
    internal var notificationToken: NotificationToken!
    /// realm is a instance of *Realm* class
    internal var realm: Realm!
    
    /**
     Init function sets up Realm instance, logins user to Realm, sets up notifications and informs when all is set.
     */
    init() {
        let username = "TestUser"
        let password = "test"
        SyncUser.logIn(with: .usernamePassword(username: username, password: password, register: true), server: URL(string: "http://127.0.0.1:9080")!) { user, error in
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
     Abstract function which handles *Realm*'s notifications.
     - Parameter notification: Instance of Realm.Notification, which is passed by Realm itself.
     - Parameter realm: Instance of Realm.
     */
    internal func notificationHandler(notification: Realm.Notification, realm: Realm) {}
    
    /**
     This function is a destructor, which stop *Realm*'s notifications.
     */
    deinit {
        notificationToken.invalidate()
    }
}
