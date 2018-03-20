//
//  Plane.swift
//  FlightRecords
//
//  Created by Martin Zid on 02/11/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//

import Foundation

/**
 PlaneViewModel prepares data for PlaneCell.
 */
class PlaneViewModel {
    
    private let plane: Plane
    
    // MARK: - Initialization
    
    init(with plane: Plane) {
        self.plane = plane
    }
    
    // MARK: - API
    
    func getRegistrationNumber() -> String {
        return plane.registrationNumber ?? NSLocalizedString("N/A", comment: "")
    }

    /**
     This function concates plane's type, model and variant. If neither is set return localized N/A.
     */
    func getPlaneInfo() -> String {
        var info = ""
        if let type = plane.type {
            info += type + " "
        }
        if let model = plane.model, let variant = plane.variant {
            info += model + "-" + variant
        } else {
            info += plane.model ?? ""
            info += plane.variant ?? ""
        }
        if(info.count == 0) {
            info = NSLocalizedString("N/A", comment: "")
        }
        return info
    }
    
    func getPlane() -> Plane {
        return plane
    }
}
