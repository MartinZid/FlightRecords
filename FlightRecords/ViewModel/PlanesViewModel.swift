//
//  Planes.swift
//  FlightRecords
//
//  Created by Martin Zid on 02/11/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//

import Foundation
import RealmSwift

/**
    PlanesViewModel is viewModel for PlanesTableViewController.
 */
class PlanesViewModel: RealmViewModel {
    /// List of all Planess
    private var planes = List<Plane>()
    
    /**
     Creates new PlanesViewModel.
     */
    override init() {
        super.init()
    }
    
    /**
     This function updates Plane's list with Planes from Realm and notifies observers about it.
     */
    private func updateList() {
        if self.planes.realm == nil {
            self.planes.removeAll()
            self.planes.append(objectsIn: self.realm.objects(Plane.self))
        }
        contentChangedObserver.send(value: ())
    }
    
    /**
     This function is called, when Realm is intialized and calls updateList method.
     */
    override func realmInitCompleted() {
        updateList()
    }
    
    /**
     This function handles notifications from Realm. In this class it only calls updateList method.
     */
    override func notificationHandler(notification: Realm.Notification, realm: Realm) {
        updateList()
    }
    
    /**
     PlanesTableView has only one section.
     - Returns: 1
     */
    func numberOfSections() -> Int {
        return 1
    }
    
    /**
     This function return number of rows for PlanesTableView.
     - Returns: number of Planes.
     */
    func numberOfPlanesInSection() -> Int {
        return planes.count
    }
    
    /**
     - Parameter indexPath: IndexPath which identifies which Plane should be used for new PlaneViewModel.
     - Returns: PlaneViewModel intialized with Plane at indexPath.
     */
    func getCellViewModel(for indexPath: IndexPath) -> PlaneViewModel {
        return PlaneViewModel(with: planes[indexPath.row])
    }
    
}
