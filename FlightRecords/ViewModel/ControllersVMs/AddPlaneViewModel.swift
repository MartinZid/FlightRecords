//
//  AddPlaneViewModel.swift
//  FlightRecords
//
//  Created by Martin Zid on 09/11/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

/**
 Add/update plane ViewModel.
 */
class AddPlaneViewModel: RealmViewModel {
    
    var type: MutableProperty<String?>
    var model: MutableProperty<String?>
    var variant: MutableProperty<String?>
    var registrationNumber: MutableProperty<String?>
    var engine: MutableProperty<Plane.Engine>
    var engineString: MutableProperty<String>
    
    private let engines = [NSLocalizedString("SE", comment: ""), NSLocalizedString("ME", comment: "")]
    
    private let plane: Plane?
    let title: String
    
    // MARK: - Initialization
    
    init(with plane: Plane?) {
        self.plane = plane
        
        title = (plane == nil ? NSLocalizedString("Add new plane", comment: "") : NSLocalizedString("Edit plane", comment: ""))
        
        type = MutableProperty(plane?.type ?? nil)
        model = MutableProperty(plane?.model ?? nil)
        variant = MutableProperty(plane?.variant ?? nil)
        registrationNumber = MutableProperty(plane?.registrationNumber ?? nil)
        engine = MutableProperty(plane?.engine ?? .single)
        engineString = MutableProperty(engines[engine.value.rawValue])
        super.init()
        
        engine <~ engineString.producer.filterMap(engine)
    }
    
    // MARK: - Helper
    
    private func engine(for value: String) -> Plane.Engine {
        let index = engines.index(where: {$0 == value})!
        let engine = Plane.Engine(rawValue: index)!
        print(engine.rawValue)
        return engine
    }
    
    // MARK: - API
    
    func getEngine(for row: Int) -> String {
        return engines[row]
    }
    
    func getEnginesCount() -> Int {
        return engines.count
    }
    
    func savePlaneToRealm() {
        let plane = self.plane ?? Plane()
        try! realm.write {
            plane.type = type.value
            plane.model = model.value
            plane.variant = variant.value
            plane.registrationNumber = registrationNumber.value
            plane.engine = engine.value
            
            realm.add(plane)
        }
    }
    
}
