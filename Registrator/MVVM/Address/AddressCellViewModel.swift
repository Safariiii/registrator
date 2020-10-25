//
//  AddressCellViewModel.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 07.10.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import Foundation

class AddressCellViewModel {
    let title: String
    let text: String
    let step: AddressStep
    let note: String?
    let isAreaNeed: Bool
    let type: AddressType
    init(title: String, text: String, step: AddressStep, note: String?, isAreaNeed: Bool, type: AddressType) {
        self.title = title
        self.text = text
        self.step = step
        self.note = note
        self.isAreaNeed = isAreaNeed
        self.type = type
    }
}
