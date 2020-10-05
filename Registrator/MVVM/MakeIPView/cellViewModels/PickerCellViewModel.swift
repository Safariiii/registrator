//
//  PickerCellViewModel.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 30.09.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import Foundation
import Firebase

class PickerCellViewModel: CellViewModel {

    var fields: [String]
    
    init(title: String, text: String, id: String, fields: [String], type: TextFieldType) {
        self.fields = fields
        super.init(title: title, text: text, id: id, type: type)
        
    }
    
    func titleForRowInPickerView(row: Int) -> String {
        return fields[row]
    }
    
    func numberOfRowsInComponent() -> Int {
        return fields.count
    }
}
