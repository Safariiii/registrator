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
    var cellIndexPath: IndexPath
    var viewController: UIViewController
    var currentSection: Int
    var giveMethod: String
    
    init(cellTitle: String, cellText: String, cellIndexPath: IndexPath, viewController: UIViewController, currentSection: Int, giveMethod: String) {
        self.cellTitle = cellTitle
        self.cellIndexPath = cellIndexPath
        self.cellText = cellText
        self.viewController = viewController
        self.currentSection = currentSection
        self.giveMethod = giveMethod
    }
}
