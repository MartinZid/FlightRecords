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

class PersonalInformationsViewModel: RealmViewModel {
    
    private let dateFormatter = DateFormatter()
    
    let name = MutableProperty<String?>(nil)
    let surname = MutableProperty<String?>(nil)
    let birthDay = MutableProperty<Date?>(nil)
    let birthDayString = MutableProperty<String?>(nil)
    let address = MutableProperty<String?>(nil)
    
    var dataSetSignal: Signal<Void, NoError>
    private var dataSetObserver: Signal<Void, NoError>.Observer
    
    var informations: PersonalInformations?
    
    override init() {
        let (dataSetSignal, dataSetObserver) = Signal<Void, NoError>.pipe()
        self.dataSetSignal = dataSetSignal
        self.dataSetObserver = dataSetObserver
        super.init()
        
        birthDayString <~ birthDay.producer.map(dateFormatter.optinalDateToString)
    }
    
    private func setPropertiesFromModel() {
        name.value = informations?.name
        surname.value = informations?.surname
        birthDay.value = informations?.birthDay
        address.value = informations?.address
        dataSetObserver.send(value: ())
    }
    
    override func realmInitCompleted() {
        informations = realm.objects(PersonalInformations.self).first
        setPropertiesFromModel()
    }
    
    func saveInfo() {
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




