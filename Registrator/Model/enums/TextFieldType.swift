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
    case buy = "Получить Документы"
    case ogrnip = "ОГРНИП: "
    
    func taxesSystem(title: String?) -> TaxesSystem {
        switch title {
        case "Общая система налогообложения (ОСНО)":
            return .OSNO
        case "Упрощенная система налогообложения (УСН)":
            return .USN
        default:
            return .none
        }
    }
    
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
            return "mainOkved"
        case .none, .buy:
            return ""
        case .addOkved:
            return "okveds"
        case .ogrnip:
            return "ogrnip"
        }
    }
    
    var note: String? {
        switch self {
        case .lastName, .firstName, .sex, .dateOfBirth, .passportDate, .address, .giveMethod, .okveds, .none, .addOkved, .buy:
            return nil
        case .middleName:
            return "Отчество указывается при наличии"
        case .citizenship:
            return "В настоящее время сервис доступен только гражданам РФ"
        case .email:
            return "На указанный адрес будет отправлен комплект документов"
        case .phoneNumber:
            return "Укажите номер мобильльного телефона"
        case .passportSeries:
            return "Необходимо указать 4 цифры серии паспорта"
        case .passportNumber:
            return "Необходимо указать 6 цифр номера паспорта"
        case .passportGiver:
            return "Необходимо указать в точности так, как указано в паспорте (без использования других склонений или сокращений с точностью до каждой точки и запятой)"
        case .passportCode:
            return "Необходимо указать 6 цифр кода подразделения"
        case .placeOfBirth:
            return "Необходимо указать в точности так, как указано в паспорте (без использования других склонений или сокращений с точностью до каждой точки и запятой)"
        case .inn:
            return "Необходимо указать 12 цифр вашего номера ИНН"
        case .snils:
            return "Необходимо указать 11 цифр вашего номера СНИЛС"
        case .taxesSystem:
            return "Выберете предпочитаемую системы налогообложения"
        case .taxesRate:
            return "Выберете предпочитаемую ставку налогообложения"
        case .ogrnip:
            return "Необходимо указать 15 цифр вашего номера ОГРНИП"
        }
    }
    
    var placeholderTitle: String? {
        switch self {
        case .lastName:
            return "Например: Иванов"
        case .firstName:
            return "Например: Иван"
        case .middleName:
            return "Например: Иванович"
        case .email:
            return "Например: mail@mail.ru"
        case .phoneNumber:
            return "Например: +7(999)999-99-99"
        case .passportSeries:
            return "Например: 1234"
        case .passportNumber:
            return "Например: 123456"
        case .passportGiver:
            return "Например: ГУ МВД России по г. Москве"
        case .passportCode:
            return "Например: 888-999"
        case .placeOfBirth:
            return "Например: г. Москва"
        case .inn:
            return "Например: 1234 5678 1234"
        case .snils:
            return "Например: 123 456 789 12"
        case .sex, .citizenship, .dateOfBirth, .taxesSystem, .taxesRate, .giveMethod, .okveds, .none, .addOkved, .passportDate, .address, .buy:
        return nil
        case .ogrnip:
            return "Например: 12345 67891 23456"
        }
    }
    
    var group: TextFieldGroup {
        switch self {
        case .lastName, .firstName, .middleName, .citizenship, .email, .phoneNumber, .passportSeries, .passportNumber, .passportGiver, .passportCode, .placeOfBirth, .address, .inn, .snils, .ogrnip:
            return .text
        case .sex,  .taxesSystem, .taxesRate:
            return .picker
        case .dateOfBirth, .passportDate:
            return .datePicker
        case .giveMethod:
            return .giveMethod
        case .okveds:
            return .okveds
        case .none, .buy:
            return .none
        case .addOkved:
            return .addOkved
        }
    }
    
    func save(text: String, id: String, collectionName: String, okveds: [OKVED]?) {
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
            db.collection("documents").document("CurrentUser").collection(collectionName).document(id).setData([firebaseName : [:] as Any], merge: true) { (error) in
                db.collection("documents").document("CurrentUser").collection(collectionName).document(id).setData([self.firebaseName : okvedsToSave as Any], merge: true)
            }
        case .okveds:
            guard let okveds = okveds else { return }
            for item in okveds {
                db.collection("documents").document("CurrentUser").collection(collectionName).document(id).setData([self.firebaseName : [:] as Any], merge: true) { (error) in
                    db.collection("documents").document("CurrentUser").collection(collectionName).document(id).setData([self.firebaseName : [item.kod: item.descr] as Any], merge: true)
                }
            }
        case .none, .buy:
            break
        case .citizenship:
            db.collection("documents").document("CurrentUser").collection(collectionName).document(id).setData([firebaseName : "РФ"], merge: true)
        default:
            db.collection("documents").document("CurrentUser").collection(collectionName).document(id).setData([firebaseName : text], merge: true)
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
        case .lastName, .firstName, .middleName, .citizenship, .dateOfBirth, .email, .passportDate, .passportGiver, .placeOfBirth, .address, .taxesSystem, .taxesRate, .giveMethod, .okveds, .none, .sex, .addOkved, .buy:
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
        case .ogrnip:
            return .ogrnip
        }
    }
}
