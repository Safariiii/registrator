//
//  AddressType.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 11.10.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import Foundation

enum AddressType: String, CaseIterable {
    case index = "Индекс"
    case region = "Субъект"
    case area = "Район"
    case city = "Город"
    case village = "Населенный пункт (поселок,  деревня и тп.)"
    case street = "Улица (проспект, площадь и тп.)"
    case house = "Дом"
    case housing = "Строение (корпус и тп.)"
    case appartement = "Квартира (комната и тп.)"
    case none = "Адрес"
    case save = "Сохранить"
    
    var note: String? {
        switch self {
        case .area:
            return "Указывается только если запись о районе, поселении, гор округе и тп. содержится в паспорте на странице с регистрацией. В случае отсутствия такой записи нажмите на ячейку с названием района, для того, что вычеркнуть запись о нем"
        default:
            return nil
        }
    }
}
