//
//  Delegates.swift
//  FlightRecords
//
//  Created by Martin Zid on 10/11/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//

import Foundation

protocol NoteViewControllerDelegate {
    func save(note: String)
}

protocol PlanesTableViewControllerDelegate {
    func userDidSelect(planeViewModel: PlaneViewModel)
}
