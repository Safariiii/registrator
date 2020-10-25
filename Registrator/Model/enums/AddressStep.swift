//
//  AddressStep.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 11.10.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import Foundation

enum AddressStep: Int {
    case search = 0
    case write = 1
    
    mutating func changeStep() {
        self = self == .search ? .write : .search
    }
    
    var fields: [AddressType] {
        switch self {
        case .search:
            return [.none, .none, .none, .none, .none, .none, .none, .none, .none, .none, .none]
        case .write:
            return [.index, .region, .area, .city, .village, .street, .house, .housing, .appartement, .save]
        }
    }
}
