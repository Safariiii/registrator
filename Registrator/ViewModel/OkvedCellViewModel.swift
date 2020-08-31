//
//  OkvedCellViewModel.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 12.08.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import Foundation

class OkvedCellViewModel {
    let kod: String
    let descr: String
    let isChosen: Bool
    
    init(kod: String, descr: String, isChosen: Bool) {
        self.kod = kod
        self.descr = descr
        self.isChosen = isChosen
    }
    
    
}
