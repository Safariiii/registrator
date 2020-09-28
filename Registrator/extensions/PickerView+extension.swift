//
//  PickerView+extension.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 24.09.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import UIKit

extension UIPickerView {

    private struct Position {
        static var section: Int = 0
    }
    
    var section: Int {
        get {
            return Position.section
        }
        set {
            Position.section = newValue
        }
    }
    
    var type: PickerViewType {
        if section == 0 {
            return .genders
        } else if section == 3 {
            switch tag {
                case 0: return .taxesSystem
                case 1: return .taxesRate
                default: return .none
            }
        }
        return .none
    }
}

enum PickerViewType {
    case genders
    case taxesSystem
    case taxesRate
    case none
}
