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

class PlanesViewModel: RealmTableViewModel<Plane> {
    
    func numberOfPlanesInSection() -> Int {
        return numberOfObjectsInSection()
    }
    
    func getCellViewModel(for indexPath: IndexPath) -> PlaneViewModel {
        return PlaneViewModel(with: collection![indexPath.row])
    }
    
    func addPlaneViewModelForNewPlane() -> AddPlaneViewModel {
        return AddPlaneViewModel(with: nil)
    }
}
