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
import CloudKit

public enum LoginErrorType {
    case iCloudError
    case serverError
}

public struct LoginError: Error {
    var type: LoginErrorType
}

class RealmViewModel {
    
    internal var notificationToken: NotificationToken!
    internal var realm: Realm!
    
    let contentChangedSignal: Signal<Void, NoError>
    internal let contentChangedObserver: Signal<Void, NoError>.Observer
    
    let userLoginSignal: Signal<Void, LoginError>
    internal let userLoginObserver: Signal<Void, LoginError>.Observer
    
    private let url = "127.0.0.1:9080"
//    private let url = "192.168.1.101:9080"
    
    init() {
        let (contentChangedSignal, contentChangedObserver) = Signal<Void, NoError>.pipe()
        self.contentChangedSignal = contentChangedSignal
        self.contentChangedObserver = contentChangedObserver
        
        let (userLoginSignal, userLoginObserver) = Signal<Void, LoginError>.pipe()
        self.userLoginSignal = userLoginSignal
        self.userLoginObserver = userLoginObserver
        
        if let user = SyncUser.current {
            setUpRealmInstance(with: user)
        } else {
            getUserICloudID() { [weak self]
                recordID, error in
                if let userID = recordID?.recordName {
                    print("received iCloudID \(userID)")
                    self?.logInUser(with: userID)
                } else {
                    userLoginObserver.send(error: LoginError.init(type: .iCloudError))
                    print("Fetched iCloudID was nil")
                }
            }
        }
    }
    
    private func logInUser(with token: String) {
        let cloudKitCredentials = SyncCredentials.cloudKit(token: token)
        SyncUser.logIn(with: cloudKitCredentials, server: URL(string: "http://" + url)!) { [weak self] user, error in
            guard let user = user else {
                self?.userLoginObserver.send(error: LoginError.init(type: .serverError))
                return
            }
            DispatchQueue.main.async {
                self?.setUpRealmInstance(with: user)
            }
        }
    }
    
    private func setUpRealmInstance(with user: SyncUser) {
        print("preparing Realm...")
        let configuration = Realm.Configuration(
            syncConfiguration: SyncConfiguration(user: user, realmURL: URL(string: "realm://" + url + "/~/testrecords03")!)
        )
        self.realm = try! Realm(configuration: configuration)
        
        print("Realm instance set up")
        
        userLoginObserver.send(value: ())
        
        self.notificationToken = self.realm.observe(self.notificationHandler)
        self.realmInitCompleted()
    }
    
    private func getUserICloudID(complete: @escaping (_ instance: CKRecordID?, _ error: Error?) -> ()) {
        let container = CKContainer.default()
        container.fetchUserRecordID() {
            recordID, error in
            if error != nil {
                print(error!.localizedDescription)
                complete(nil, error)
            } else {
                print("fetched ID \(recordID?.recordName ?? "nothing")")
                complete(recordID, nil)
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
        if let notificationToken = notificationToken {
            notificationToken.invalidate()
        }
    }
}
