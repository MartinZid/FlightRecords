//
//  Planes.swift
//  FlightRecords
//
//  Created by Martin Zid on 02/11/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//

import Foundation
import RealmSwift
import ReactiveSwift
import Result

class PlanesViewModel: RealmViewModel {
    
    private var planes: Results<Plane>?
    var planesNotificationsToken: NotificationToken? = nil
    
    let planesChangedSignal: Signal<RealmCollectionChange<Results<Plane>>, NoError>
    private let planesChangedObserver: Signal<RealmCollectionChange<Results<Plane>>, NoError>.Observer
    
    override init() {
        let (planesChangedSignal, planesChangedObserver) = Signal<RealmCollectionChange<Results<Plane>>, NoError>.pipe()
        self.planesChangedSignal = planesChangedSignal
        self.planesChangedObserver = planesChangedObserver
        super.init()
    }
    
    private func updateList() {
        planes = realm.objects(Plane.self)
        planesNotificationsToken = planes?.observe{ [weak self] (changes: RealmCollectionChange<Results<Plane>>) in
            self?.planesChangedObserver.send(value: changes)
        }
    }
    
    override func realmInitCompleted() {
        updateList()
    }

    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfPlanesInSection() -> Int {
        if let list = planes {
            return list.count
        }
        return 0
    }
    
    func getCellViewModel(for indexPath: IndexPath) -> PlaneViewModel {
        return PlaneViewModel(with: planes![indexPath.row])
    }
    
    func addPlaneViewModelForNewPlane() -> AddPlaneViewModel {
        return AddPlaneViewModel(with: nil)
    }
}
