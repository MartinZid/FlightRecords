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
    internal var notificationToken: NotificationToken!
    internal var realm: Realm!
    
    init() {
        let username = "TestUser"
        let password = "test"
        
        SyncUser.logIn(with: .usernamePassword(username: username, password: password, register: false), server: URL(string: "http://127.0.0.1:9080")!) { user, error in
            guard let user = user else {
                fatalError(String(describing: error))
            }
            
            DispatchQueue.main.async {
                let configuration = Realm.Configuration(
                    syncConfiguration: SyncConfiguration(user: user, realmURL: URL(string: "realm://127.0.0.1:9080/~/testrecords")!)
                )
                self.realm = try! Realm(configuration: configuration)
                
                self.notificationToken = self.realm.addNotificationBlock(self.notificationHandler)
                self.realmInitCompleted()
            }
        }
    }
    
    internal func realmInitCompleted() {}
    
    internal func notificationHandler(notification: Realm.Notification, realm: Realm) {}
    
    deinit {
        notificationToken.stop()
    }
}
