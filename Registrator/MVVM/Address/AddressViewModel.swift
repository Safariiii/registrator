//
//  AddressViewVeiwModel.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 07.10.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

class AddressVeiwModel {

    var dataArr: [FiasData]?
    var chosenAddress: Address?
    let id: String
    var router: AddressRouter?
    let docType: DocType
    let disposeBag = DisposeBag()
    var addressType: AddressType = .region
    let fields: [AddressType] = [.region, .town, .street]
    
    
    init(id: String, docType: DocType) {
        self.id = id
        self.docType = docType
    }
    
    var numberOfRows: Int {
        return AddressType.allCases.count
    }
    
    var numberOfSections: Int {
        AddressType.allCases.count
    }
    
    func titleForRowInPickerView(row: Int) -> String {
        if let data = dataArr {
            return data[row].PresentRow!
        } else {
            return regions[row]
        }
    }
    
    var numberOfRowsInComponent: Int {
        return regions.count
    }
    
    func didSelectRowInPickerView(row: Int, completion: @escaping(() -> Void)) {
        addressType.makeSearchRequest(text: regions[row]) { [weak self] (data) in
            self?.dataArr = data
            completion()
        }
    }
    
    func didSelectRowAt(row: Int, completion: @escaping(() -> Void)) {
//        guard let address = step == .search ? dataArr[row] : chosenAddress else { return }
//        step.fields[row].didSelectRow(address: address, id: id, docType: docType) { [weak self] (address) in
//            if let newAdr = address {
//                self?.chosenAddress = newAdr
//                completion()
//            } else {
//                self?.router.dismissModule()
//            }
//        }
    }
    
    func cellViewModel(for indexPath: IndexPath) -> AddressCellViewModel? {
        let item = AddressType.allCases[indexPath.row]
        var text = ""
        return AddressCellViewModel(title: item.rawValue, text: text, note: item.note, type: item)
    }
}

fileprivate let regions = [
    "Алтайский край",
    "Амурская область",
    "Архангельская область",
    "Астраханская область",
    "Белгородская область",
    "Брянская область",
    "Владимирская область",
    "Волгоградская область",
    "Вологодская область",
    "Воронежская область",
    "г. Москва",
    "Еврейская автономная область",
    "Забайкальский край",
    "Ивановская область",
    "Иные территории, включая город и космодром Байконур",
    "Иркутская область",
    "Кабардино-Балкарская Республика",
    "Калининградская область",
    "Калужская область",
    "Камчатский край",
    "Карачаево-Черкесская Республика",
    "Кемеровская область - Кузбасс",
    "Кировская область",
    "Костромская область",
    "Краснодарский край",
    "Красноярский край",
    "Курганская область",
    "Курская область",
    "Ленинградская область",
    "Липецкая область",
    "Магаданская область",
    "Московская область",
    "Мурманская область",
    "Ненецкий автономный округ",
    "Нижегородская область",
    "Новгородская область",
    "Новосибирская область",
    "Омская область",
    "Оренбургская область",
    "Орловская область",
    "Пензенская область",
    "Пермский край",
    "Приморский край",
    "Псковская область",
    "Республика Адыгея (Адыгея)",
    "Республика Алтай",
    "Республика Башкортостан",
    "Республика Бурятия",
    "Республика Дагестан",
    "Республика Ингушетия",
    "Республика Калмыкия",
    "Республика Карелия",
    "Республика Коми",
    "Республика Крым",
    "Республика Марий Эл",
    "Республика Мордовия",
    "Республика Саха (Якутия)",
    "Республика Северная Осетия - Алания",
    "Республика Татарстан (Татарстан)",
    "Республика Тыва",
    "Республика Хакасия",
    "Ростовская область",
    "Рязанская область",
    "Самарская область",
    "Санкт-Петербург",
    "Саратовская область",
    "Сахалинская область",
    "Свердловская область",
    "Севастополь",
    "Смоленская область",
    "Ставропольский край",
    "Тамбовская область",
    "Тверская область",
    "Томская область",
    "Тульская область",
    "Тюменская область",
    "Удмуртская Республика",
    "Ульяновская область",
    "Хабаровский край",
    "Ханты-Мансийский автономный округ - Югра",
    "Челябинская область",
    "Чеченская Республика",
    "Чувашская Республика - Чувашия",
    "Чукотский автономный округ",
    "Ямало-Ненецкий автономный округ",
    "Ярославская область"
]
