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

/**
 ViewModel associated with displaying all planes.
 */
class PlanesViewModel: RealmTableViewModel<Plane> {
    
    // MARK: - API
    
    func numberOfPlanesInSection() -> Int {
        return numberOfObjectsInSection()
    }
    
    func getCellViewModel(for indexPath: IndexPath) -> PlaneViewModel {
        return PlaneViewModel(with: collection![indexPath.row])
    }
    
    func addPlaneViewModelForNewPlane() -> AddPlaneViewModel {
        return AddPlaneViewModel(with: nil)
    }
    
    func addPlaneViewModelForPlane(at indexPath: IndexPath) -> AddPlaneViewModel {
        return AddPlaneViewModel(with: collection![indexPath.row])
    }
    
    func deletePlane(at indexPath: IndexPath) {
        deletedObject = Plane(value: collection![indexPath.row])
        deleteObject(at: indexPath)
    }
}
