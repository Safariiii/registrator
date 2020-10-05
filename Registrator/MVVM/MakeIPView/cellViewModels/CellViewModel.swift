//
//  CellViewModel.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 30.09.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import Foundation
import Firebase

class CellViewModel {
    var title: String
    var text: String
    var id: String
    var type: TextFieldType
    
    init(title: String, text: String, id: String, type: TextFieldType) {
        self.title = title
        self.text = text
        self.id = id
        self.type = type
    }
    
    func save(text: String) {
        type.save(text: text, id: id, okveds: nil)
    }
}
