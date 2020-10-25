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
    var placeholder: String?
    var docType: DocType
    
    init(title: String, text: String, id: String, type: TextFieldType, docType: DocType) {
        self.title = title
        self.text = text
        self.id = id
        self.type = type
        self.docType = docType
        if let text = type.placeholderTitle {
            self.placeholder = text
        }
    }
    
    func save(text: String) {
        type.save(text: text, id: id, collectionName: docType.collectionName, okveds: nil)
    }
}
