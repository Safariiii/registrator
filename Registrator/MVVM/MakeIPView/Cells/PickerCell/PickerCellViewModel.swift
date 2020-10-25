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
    var taxSystem: TaxesSystem?
    
    init(title: String, text: String, id: String, taxSystem: TaxesSystem?, fields: [String], type: TextFieldType, docType: DocType) {
        self.taxSystem = taxSystem
        self.fields = fields
        super.init(title: title, text: text, id: id, type: type, docType: docType)
        
    }
    
    var canShowTaxRate: Bool {
        if type == .taxesRate {
            if taxSystem == .OSNO {
                return false
            }
        }
        return true
    }
    
    func titleForRowInPickerView(row: Int) -> String {
        return fields[row]
    }
    
    func numberOfRowsInComponent() -> Int {
        return fields.count
    }
}
