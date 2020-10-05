//
//  OkvedTypeCellViewModel.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 30.09.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import Foundation
class OkvedTypeCellViewModel: CellViewModel {
    
    init(text: String, id: String, type: TextFieldType) {
        super.init(title: "", text: text, id: id, type: type)
    }

}


