//
//  File.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 22.09.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import Foundation

struct File {
    var lastName: String?
    var firstName: String?
    var middleName: String?
    var sex: String?
    var citizenship: String?
    var dateOfBirth: String?
    var email: String?
    var phoneNumber: String?
    var passportSeries: String?
    var passportNumber: String?
    var passportDate: String?
    var passportGiver: String?
    var passportCode: String?
    var placeOfBirth: String?
    var address: String?
    var inn: String?
    var snils: String?
    var taxesSystem: String?
    var taxesRate: String?
    var giveMethod: String?
    var okveds: [OKVED]?
    var mainOkved: [OKVED]?
    var ogrnip: String?
    var usnGiveTime: String?
    
    let giveMethods = ["Лично", "По доверенности"]
    
    var errors: [String] {
        var errors: [String] = []
        if lastName == "" {
            errors.append("Не указана фамилия")
        }
        if firstName == "" {
            errors.append("Не указано имя")
        }
        if sex == "" {
            errors.append("Не указан пол")
        }
        if dateOfBirth == "" {
            errors.append("Не указана дата рождения")
        }
        if email == "" {
            errors.append("Не указан Email")
        }
        if let num = phoneNumber {
            if num.count < 16 {
                errors.append("Номер телефона введен не полностью")
            }
        }
        if let num = passportSeries {
            if num.count < 4 {
                errors.append("Серия паспорта введена не полностью")
            }
        }
        if let num = passportNumber {
            if num.count < 6 {
                errors.append("Номер паспорта введен не полностью")
            }
        }
        if passportDate == "" {
            errors.append("Не указана дата выдачи паспорта")
        }
        if passportGiver == "" {
            errors.append("Не указан орган, выдавший паспорт")
        }
        if let num = passportCode {
            if num.count < 7 {
                errors.append("Код подразделения паспорта введен не полностью")
            }
        }
        if placeOfBirth == "" {
            errors.append("Не указано место рождения")
        }
        if address == "" {
            errors.append("Не указан адрес регистрации")
        }
        if let num = inn {
            if num.count < 14 {
                errors.append("ИНН введен не полностью")
            }
        }
        if let num = snils {
            if num.count < 14 {
                errors.append("СНИЛС введен не полностью")
            }
        }
        if let num = ogrnip {
            if num.count < 17 {
                errors.append("ОГРНИП введен не полностью")
            }
        }
        if taxesSystem == "" {
            errors.append("Не указана система налогообложения")
        }
        if giveMethod == "" {
            errors.append("Не указана способ подачи документов")
        }
        if okveds == [] {
            errors.append("Не выбран ни один код ОКВЭД")
        }
        if usnGiveTime == "" {
            errors.append("Не указан момент перехода на УСН")
        }
        return errors
    }
    
    var errorMessage: String {
        var message = "При заполнении формы были допущены следующие ошибки: "
        var i = 1
        for item in errors {
            message += "\(i).\(item). "
            i += 1
        }
        message += "В случае если данные ошибки не будут исправлены, налоговый орган откажет Вам в регистрации документов. Просим проверить форму еще раз и ввести недостающие данные."
        return message
    }
    
    mutating func cellText(title: String, row: Int) -> String {
        switch title {
        case "Фамилия: ":
            guard let txt = lastName else { return "" }
            return txt
        case "Имя: ":
            guard let txt = firstName else { return "" }
            return txt
        case "Отчество: ":
            guard let txt = middleName else { return "" }
            return txt
        case "Пол: ":
            guard let txt = sex else { return "" }
            return txt
        case "Гражданство: ":
            guard let txt = citizenship else { return "" }
            return txt
        case "Дата рождения: ":
            guard let txt = dateOfBirth else { return "" }
            return txt
        case "E-mail: ":
            guard let txt = email else { return "" }
            return txt
        case "Номер телефона: ":
            guard let txt = phoneNumber else { return "" }
            return txt
        case "Серия паспорта: ":
            guard let txt = passportSeries else { return "" }
            return txt
        case "Номер паспорта: ":
            guard let txt = passportNumber else { return "" }
            return txt
        case "Дата выдачи: ":
            guard let txt = passportDate else { return "" }
            return txt
        case "Кем выдан: ":
            guard let txt = passportGiver else { return "" }
            return txt
        case "Код подразделения: ":
            guard let txt = passportCode else { return "" }
            return txt
        case "Место рождения: ":
            guard let txt = placeOfBirth else { return "" }
            return txt
        case "Адрес регистрации: ":
            guard let txt = address else { return "" }
            return txt
        case "ИНН: ":
            guard let txt = inn else { return "" }
            return txt
        case "СНИЛС: ":
            guard let txt = snils else { return "" }
            return txt
        case "ОГРНИП: ":
            guard let txt = ogrnip else { return "" }
            return txt
        case "Система нологообложения: ":
            guard let txt = taxesSystem else { return "" }
            return txt
        case "Ставка налогообложения: ":
            guard let txt = taxesRate else { return "" }
            return txt
        case "Далее":
            return ""
        case "Оквэд":
            guard let txt = okveds else { return "" }
            return "\(txt[row].kod). \(txt[row].descr)"
        case "Метод":
            return giveMethods[row]
        case "Момент перехода на УСН: ":
            guard let txt = usnGiveTime else { return "" }
            return txt
        default:
            return ""
        }
    }
}
