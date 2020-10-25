//
//  TextCellViewModel.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 30.09.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import Foundation
import Firebase

class TextCellViewModel: CellViewModel {

    var validateType: ValidateType
    
    init(title: String, text: String, id: String, validateType: ValidateType, type: TextFieldType, docType: DocType) {
        self.validateType = validateType
        super.init(title: title, text: text, id: id, type: type, docType: docType)
    }
    
}
