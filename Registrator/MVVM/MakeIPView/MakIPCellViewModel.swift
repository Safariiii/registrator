//
//  MakIPCellViewModel.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 23.07.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import UIKit

class MakIPCellViewModel {
    
    var cellTitle: String
    var cellText: String
    var tag: Int
    var currentSection: Int
    var accessoryType: UITableViewCell.AccessoryType
    
    init(cellTitle: String, cellText: String, tag: Int, currentSection: Int, giveMethod: String) {
        self.cellTitle = cellTitle
        self.tag = tag
        self.cellText = cellText
        self.currentSection = currentSection
        self.accessoryType = giveMethod == cellTitle && giveMethod != "" ? .checkmark : .none
    }
    
    var cellType: cellType {
        if cellTitle == "Кнопка добавить ОКВЭД" {
            return .addOkvedButton
        } else if cellTitle != "" {
            return .normal
        } else {
            return .nextButton
        }
    }
    
    var sectionType: sectionType {
        if currentSection == 0 || currentSection == 1 || currentSection == 3 {
            return .normal
        } else if currentSection == 2 {
            return .okved
        } else {
            return .giveMethod
        }
    }
    
    enum cellType {
        case normal
        case addOkvedButton
        case nextButton
    }
    
    enum sectionType {
        case okved
        case normal
        case giveMethod
    }
    
}
