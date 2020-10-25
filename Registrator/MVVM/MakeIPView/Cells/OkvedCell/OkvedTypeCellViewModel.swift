//
//  OkvedTypeCellViewModel.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 30.09.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import Foundation
class OkvedTypeCellViewModel: CellViewModel {
    
    var mainOkved: String
    
    init(text: String, id: String, type: TextFieldType, mainOkved: String, docType: DocType) {
        self.mainOkved = mainOkved
        super.init(title: "", text: text, id: id, type: type, docType: docType)
    }

}


