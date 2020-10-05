//
//  Step.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 01.10.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import Foundation

enum Step: Int, CaseIterable {
    case step1 = 0
    case step2 = 1
    case step3 = 2
    case step4 = 3
    case step5 = 4
    
    static var okveds: [OKVED] = []
    
    func createNewDoc(id: String) {
        for step in Step.sortedSteps {
            for item in step.fields {
                item.save(text: "", id: id, okveds: [])
            }
        }
    }
    
    mutating func nextSection() {
        if let nextStep = Step(rawValue: self.rawValue + 1) {
            self = nextStep
        }
    }
    
    mutating func prevSection() {
        if let prevStep = Step(rawValue: self.rawValue - 1) {
            self = prevStep
        }
    }
    
    var title: String {
        switch self {
        case .step1:
            return "Шаг 1: Личная информация"
        case .step2:
            return "Шаг 2: Паспортные данные"
        case .step3:
            return "Шаг 3: ОКВЭД"
        case .step4:
            return "Шаг 4: Налогообложение"
        case .step5:
            return "Шаг 5: Способ подачи документов"
        }
    }
    
    var fields: [TextFieldType] {
        switch self {
        case .step1:
            return [.lastName, .firstName, .middleName, .sex, .citizenship, .dateOfBirth, .email, .phoneNumber, .none]
        case .step2:
            return [.passportSeries, .passportNumber, .passportDate, .passportGiver, .passportCode, .placeOfBirth, .address, .inn, .snils, .none]
        case .step3:
            var okv: [TextFieldType] = []
            for _ in 0..<Step.okveds.count {
                okv.append(.okveds)
            }
            okv.append(.addOkved)
            okv.append(.none)
            if okv.count == 2 {
                okv = [.addOkved, .none]
            }
            return okv
        case .step4:
            return [.taxesSystem, .taxesRate, .none]
        case .step5:
            return [.giveMethod, .giveMethod, .none]
        }
    }
    
    static var sortedSteps: [Step] = [.step1, .step2, .step3, .step4, .step5]
}
