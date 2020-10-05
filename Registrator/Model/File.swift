//
//  File.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 22.09.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import Foundation

struct File {
    var lastName: String = ""
    var firstName: String = ""
    var middleName: String = ""
    var sex: String = ""
    var citizenship: String = ""
    var dateOfBirth: String = ""
    var email: String = ""
    var phoneNumber: String = ""
    var passportSeries: String = ""
    var passportNumber: String = ""
    var passportDate: String = ""
    var passportGiver: String = ""
    var passportCode: String = ""
    var placeOfBirth: String = ""
    var address: String = ""
    var inn: String = ""
    var snils: String = ""
    var taxesSystem: String = ""
    var taxesRate: String = ""
    var giveMethod: String = ""
    var okveds: [OKVED] = []
    
    let giveMethods = ["Лично", "По доверенности"]
    
    mutating func setTextField(text: String, type: TextFieldType) {
        switch type {
        case .lastName:
            lastName = text
        case .firstName:
            firstName = text
        case .middleName:
            middleName = text
        case .sex:
            sex = text
        case .citizenship:
            citizenship = text
        case .dateOfBirth:
            dateOfBirth = text
        case .email:
            email = text
        case .phoneNumber:
            phoneNumber = text
        case .passportSeries:
            passportSeries = text
        case .passportNumber:
            passportNumber = text
        case .passportDate:
            passportDate = text
        case .passportGiver:
            passportGiver = text
        case .passportCode:
            passportCode = text
        case .placeOfBirth:
            placeOfBirth = text
        case .address:
            address = text
        case .inn:
            inn = text
        case .snils:
            snils = text
        case .taxesSystem:
            taxesSystem = text
        case .taxesRate:
            taxesRate = text
        case .giveMethod:
            giveMethod = text
        default:
            break
        }
    }
    
    mutating func cellText(title: String, row: Int) -> String {
        switch title {
        case "Фамилия: ":
            return lastName
        case "Имя: ":
            return firstName
        case "Отчество: ":
            return middleName
        case "Пол: ":
            return sex
        case "Гражданство: ":
            return citizenship
        case "Дата рождения: ":
            return dateOfBirth
        case "E-mail: ":
            return email
        case "Номер телефона: ":
            return phoneNumber
        case "Серия паспорта: ":
            return passportSeries
        case "Номер паспорта: ":
            return passportNumber
        case "Дата выдачи: ":
            return passportDate
        case "Кем выдан: ":
            return passportGiver
        case "Код подразделения: ":
            return passportCode
        case "Место рождения: ":
            return placeOfBirth
        case "Адрес регистрации: ":
            return address
        case "ИНН: ":
            return inn
        case "СНИЛС: ":
            return snils
        case "Система нологообложения: ":
            return taxesSystem
        case "Ставка налогообложения: ":
            return taxesRate
        case "Далее":
            return ""
        case "Оквэд":
            return "\(okveds[row].kod). \(okveds[row].descr)"
        case "Метод":
            return giveMethods[row]
        default:
            return ""
        }
    }
}
