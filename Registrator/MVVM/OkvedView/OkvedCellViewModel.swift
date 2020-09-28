//
//  OkvedCellViewModel.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 12.08.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import UIKit

class OkvedCellViewModel {
    let text: String
    let backgroundColor: UIColor
    
    init(text: String, isChosen: Bool) {
        self.text = text
        if isChosen {
            backgroundColor = .green
        } else {
            backgroundColor = .white
        }
    }
    
    
}
