//
//  PersonalInformationsViewModel.swift
//  FlightRecords
//
//  Created by Martin Zid on 30/11/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//

import Foundation
import ReactiveSwift
import ReactiveCocoa
import Result

/**
 PersonalInformationsViewModel saves and load PersonalInformations to/from the Realm.
 */
class PersonalInformationsViewModel: RealmViewModel {
    
    private let dateFormatter = DateFormatter()
    
    let name = MutableProperty<String?>(nil)
    let surname = MutableProperty<String?>(nil)
    let birthDay = MutableProperty<Date?>(nil)
    let birthDayString = MutableProperty<String?>(nil)
    let address = MutableProperty<String?>(nil)
    
    var informations: PersonalInformations?
    
    // MARK: - Initialization
    
    override init() {
        super.init()
        
        birthDayString <~ birthDay.producer.map(dateFormatter.optinalDateToString)
    }
    
    // MARK: - Helpers
    
    private func setPropertiesFromModel() {
        name.value = informations?.name
        surname.value = informations?.surname
        birthDay.value = informations?.birthDay
        address.value = informations?.address
    }
    
    override func realmInitCompleted() {
        informations = realm.objects(PersonalInformations.self).first
        setPropertiesFromModel()
    }
    
    // MARK: - API
    
    func saveInfoToRealm() {
        let informations = self.informations ?? PersonalInformations()
        try! realm.write {
            informations.name = name.value
            informations.surname = surname.value
            informations.birthDay = birthDay.value
            informations.address = address.value
            realm.add(informations)
        }
    }
}




