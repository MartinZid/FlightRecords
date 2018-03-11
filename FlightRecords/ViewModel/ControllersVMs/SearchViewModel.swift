//
//  SearchViewModel.swift
//  FlightRecords
//
//  Created by Martin Zid on 24/11/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//

import Foundation
import ReactiveSwift

class SearchViewModel {
    
    private let dateFormatter = DateFormatter()
    
    var searchText: MutableProperty<String?>
    var flightsSwitch: MutableProperty<Bool>
    var fstdSwitch: MutableProperty<Bool>
    var planeType: MutableProperty<String?>
    var plane: MutableProperty<Plane?>
    var planeLabel = MutableProperty<String>("")
    
    var fromDate: MutableProperty<Date?>
    var fromDateString = MutableProperty<String?>(nil)
    var toDate: MutableProperty<Date?>
    var toDateString = MutableProperty<String?>(nil)
    
    var searchConfiguration: SearchConfiguration?
    
    init(with configuration: SearchConfiguration?) {
        searchConfiguration = configuration
        
        searchText = MutableProperty(searchConfiguration?.searchText)
        flightsSwitch = MutableProperty(searchConfiguration?.flightsSwitch ?? true)
        fstdSwitch = MutableProperty(searchConfiguration?.fstdSwitch ?? true)
        planeType = MutableProperty(searchConfiguration?.planeType)
        plane = MutableProperty(searchConfiguration?.plane)
        
        fromDate = MutableProperty(searchConfiguration?.fromDate)
        toDate = MutableProperty(searchConfiguration?.toDate)
        
        planeLabel <~ plane.producer.filterMap(setPlaneLabel)
        fromDateString <~ fromDate.producer.map(dateFormatter.optinalDateToString)
        toDateString <~ toDate.producer.map(dateFormatter.optinalDateToString)
        
        fromDate.signal.observeValues{ [weak self] value in
            if let fromDate = value {
                if let toDate = self?.toDate.value {
                    if toDate.timeIntervalSince(fromDate) < 0 {
                        self?.toDate.value = fromDate
                    }
                }
            }
        }
        
        if searchConfiguration == nil {
            searchConfiguration = SearchConfiguration()
        }
    }
    
    private func setPlaneLabel(plane: Plane?) -> String {
        var label = plane?.registrationNumber ?? NSLocalizedString("N/A", comment: "")
        if plane == nil {
            label = ""
        }
        return label
    }
    
    func setPlane(from planeViewModel: PlaneViewModel) {
        plane.value = planeViewModel.getPlane()
    }
    
    func getDefaultToDateValue() -> Date {
        if toDate.value == nil {
            if let fromDate = fromDate.value {
                if Date().timeIntervalSince(fromDate) < 0 {
                    return fromDate
                } else {
                    return Date()
                }
            } else {
                return Date()
            }
        }
        return toDate.value!
    }
    
    func getConfiguration() -> SearchConfiguration {
        searchConfiguration?.searchText = searchText.value
        searchConfiguration?.flightsSwitch = flightsSwitch.value
        searchConfiguration?.fstdSwitch = fstdSwitch.value
        searchConfiguration?.planeType = planeType.value
        searchConfiguration?.plane = plane.value
        searchConfiguration?.fromDate = fromDate.value
        searchConfiguration?.toDate = toDate.value
        return searchConfiguration!
    }
    
    func clearSearchParameters() {
        searchText.value = nil
        flightsSwitch.value = true
        fstdSwitch.value = true
        planeType.value = nil
        plane.value = nil
        fromDate.value = nil
        toDate.value = nil
    }
    
    func clearPlane() {
        plane.value = nil
    }
}








