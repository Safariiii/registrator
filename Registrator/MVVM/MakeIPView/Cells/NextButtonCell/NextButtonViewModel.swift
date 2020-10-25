//
//  NextButtonViewModel.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 30.09.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import Foundation

class NextButtonViewModel: CellViewModel {
    
    init(type: TextFieldType, docType: DocType) {
        super.init(title: type.rawValue, text: "", id: "", type: type, docType: docType)
    }
}
