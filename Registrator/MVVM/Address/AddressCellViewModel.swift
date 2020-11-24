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
    let note: String?
    let type: AddressType
    init(title: String, text: String, note: String?, type: AddressType) {
        self.title = title
        self.text = text
        self.note = note
        self.type = type
    }
}
