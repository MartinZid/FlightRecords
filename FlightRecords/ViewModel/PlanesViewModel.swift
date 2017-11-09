//
//  Planes.swift
//  FlightRecords
//
//  Created by Martin Zid on 02/11/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//

import Foundation
import RealmSwift

class PlanesViewModel: RealmViewModel {
    private var planes = List<Plane>()
    
    override init() {
        super.init()
    }
    
    private func updateList() {
        if self.planes.realm == nil {
            self.planes.removeAll()
            self.planes.append(objectsIn: self.realm.objects(Plane.self))
        }
        contentChangedObserver.send(value: ())
    }
    
    override func realmInitCompleted() {
        updateList()
    }
    
    override func notificationHandler(notification: Realm.Notification, realm: Realm) {
        updateList()
    }
    

    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfPlanesInSection() -> Int {
        return planes.count
    }
    
    func getCellViewModel(for indexPath: IndexPath) -> PlaneViewModel {
        return PlaneViewModel(with: planes[indexPath.row])
    }
    
    func addPlaneViewModelForNewPlane() -> AddPlaneViewModel {
        return AddPlaneViewModel(with: nil)
    }
    
}
