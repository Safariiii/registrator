//
//  TextFieldGroup.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 01.10.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import Foundation

enum TextFieldGroup {
    case text
    case picker
    case datePicker
    case giveMethod
    case okveds
    case none
    case addOkved
    
    func cellViewModel(indexPath: IndexPath, item: TextFieldType, text: String, newFile: File, id: String, docType: DocType) -> CellViewModel? {        
        switch self {
        case .text:
            return TextCellViewModel(title: item.rawValue, text: text, id: id, validateType: item.validateType, type: item, docType: docType)
        case .picker:
            return PickerCellViewModel(title: item.rawValue, text: text, id: id, taxSystem: item.taxesSystem(title: newFile.taxesSystem), fields: item.selectFields, type: item, docType: docType)
        case .datePicker:
            return CellViewModel(title: item.rawValue, text: text, id: id, type: item, docType: docType)
        case .giveMethod:
            return GiveMethodCellViewModel(title: text, id: id, giveMethod: newFile.giveMethod, type: item, docType: docType)
        case .okveds:
            guard let mo = newFile.mainOkved else { return CellViewModel(title: "", text: "", id: "", type: .none, docType: .makeIP) }
            let mainOkved = "\(mo[0].kod). \(mo[0].descr)"
            return OkvedTypeCellViewModel(text: text, id: id, type: item, mainOkved: mainOkved, docType: docType)
        case .none:
            return NextButtonViewModel(type: item, docType: docType)
        case .addOkved:
            guard let okveds = newFile.okveds else { return CellViewModel(title: "", text: "", id: "", type: .none, docType: .makeIP) }
            return AddOkvedViewModel(okveds: okveds, docType: docType)
        }
    }
}
