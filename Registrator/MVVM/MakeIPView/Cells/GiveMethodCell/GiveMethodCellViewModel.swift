//
//  GiveMethodCellViewModel.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 30.09.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import Foundation

class GiveMethodCellViewModel: CellViewModel {

    var giveMethod: String? = ""
    
    init(title: String, id: String, giveMethod: String?, type: TextFieldType, docType: DocType) {
        self.giveMethod = giveMethod
        super.init(title: title, text: "", id: id, type: type, docType: docType)
    }
}
