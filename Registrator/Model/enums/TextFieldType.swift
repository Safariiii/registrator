//
//  TextFieldType.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 01.10.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import Foundation
import Firebase

fileprivate let genders = ["", "Мужской", "Женский"]
fileprivate let taxSystem = ["", "Общая система налогообложения (ОСНО)", "Упрощенная система налогообложения (УСН)"]
fileprivate let taxRate = ["", "Доходы (6% от всех доходов)", "Доходы минус расходы (от 5% до 15%)"]

enum TextFieldType: String, CaseIterable {
    case lastName = "Фамилия: "
    case firstName = "Имя: "
    case middleName = "Отчество: "
    case sex = "Пол: "
    case citizenship = "Гражданство: "
    case dateOfBirth = "Дата рождения: "
    case email = "E-mail: "
    case phoneNumber = "Номер телефона: "
    case passportSeries = "Серия паспорта: "
    case passportNumber = "Номер паспорта: "
    case passportDate = "Дата выдачи: "
    case passportGiver = "Кем выдан: "
    case passportCode = "Код подразделения: "
    case placeOfBirth = "Место рождения: "
    case address = "Адрес регистрации: "
    case inn = "ИНН: "
    case snils = "СНИЛС: "
    case taxesSystem = "Система нологообложения: "
    case taxesRate = "Ставка налогообложения: "
    case giveMethod = "Метод"
    case okveds = "Оквэд"
    case none = "Далее"
    case addOkved = "Добавить ОКВЭД"
    
    var firebaseName: String {
        switch self {
        case .lastName:
            return "lastName"
        case .firstName:
            return "firstName"
        case .middleName:
            return "middleName"
        case .sex:
            return "sex"
        case .citizenship:
            return "citizenship"
        case .dateOfBirth:
            return "dateOfBirth"
        case .email:
            return "email"
        case .phoneNumber:
            return "phoneNumber"
        case .passportSeries:
            return "passportSeries"
        case .passportNumber:
            return "passportNumber"
        case .passportDate:
            return "passportDate"
        case .passportGiver:
            return "passportGiver"
        case .passportCode:
            return "passportCode"
        case .placeOfBirth:
            return "placeOfBirth"
        case .address:
            return "address"
        case .inn:
            return "inn"
        case .snils:
            return "snils"
        case .taxesSystem:
            return "taxesSystem"
        case .taxesRate:
            return "taxesRate"
        case .giveMethod:
            return "giveMethod"
        case .okveds:
            return "okveds"
        case .none:
            return ""
        case .addOkved:
            return "okveds"
        }
    }
    
    var group: TextFieldGroup {
        switch self {
        case .lastName, .firstName, .middleName, .citizenship, .email, .phoneNumber, .passportSeries, .passportNumber, .passportGiver, .passportCode, .placeOfBirth, .address, .inn, .snils:
            return .text
        case .sex,  .taxesSystem, .taxesRate:
            return .picker
        case .dateOfBirth, .passportDate:
            return .datePicker
        case .giveMethod:
            return .giveMethod
        case .okveds:
            return .okveds
        case .none:
            return .none
        case .addOkved:
            return .addOkved
        }
    }
    
    func save(text: String, id: String, okveds: [OKVED]?) {
        let db = Firestore.firestore()
        switch self {
        case .addOkved:
            guard let okveds = okveds else { return }
            var okvedsToSave: [String : String] = [:]
            for item in okveds {
                let kod = item.kod
                let descr = item.descr
                okvedsToSave[kod] = descr
            }
            db.collection("documents").document("CurrentUser").collection("IP").document(id).setData([firebaseName : [:] as Any], merge: true) { (error) in
                db.collection("documents").document("CurrentUser").collection("IP").document(id).setData([self.firebaseName : okvedsToSave as Any], merge: true) 
            }
        case .none, .okveds:
            break
        default:
            db.collection("documents").document("CurrentUser").collection("IP").document(id).setData([firebaseName : text], merge: true)
        }
    }

    var selectFields: [String] {
        switch self {
        case .sex:
            return genders
        case .taxesSystem:
            return taxSystem
        case .taxesRate:
            return taxRate
        default:
            return []
        }
    }
    
    var validateType: ValidateType {
        switch self {
        case .lastName, .firstName, .middleName, .citizenship, .dateOfBirth, .email, .passportDate, .passportGiver, .placeOfBirth, .address, .taxesSystem, .taxesRate, .giveMethod, .okveds, .none, .sex, .addOkved:
            return .none
        case .phoneNumber:
            return .phoneNumber
        case .passportSeries:
            return .passportSeries
        case .passportNumber:
            return .passportNumber
        case .passportCode:
            return .passportCode
        case .inn:
            return .inn
        case .snils:
            return .snils
        }
    }
}
