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
    
    static var searchCount = 0
    
    var fields: [AddressType] {
        switch self {
        case .search:
            var itemsArr = [AddressType]()
            if AddressStep.searchCount == 0 {
                return []
            }
            for _ in 0 ..< AddressStep.searchCount - 1 {
                itemsArr.append(.none)
            }
            itemsArr.append(.parsed)
            
            return itemsArr
        case .write:
            return [.index, .region, .area, .city, .village, .street, .house, .housing, .appartement, .save]
        }
    }
}
