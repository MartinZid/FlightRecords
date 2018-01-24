//
//  Plane.swift
//  FlightRecords
//
//  Created by Martin Zid on 02/11/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//

import Foundation

class PlaneViewModel {
    
    private let plane: Plane
    
    init(with plane: Plane) {
        self.plane = plane
    }
    
    func getRegistrationNumber() -> String {
        return plane.registrationNumber ?? NSLocalizedString("N/A", comment: "")
    }

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
