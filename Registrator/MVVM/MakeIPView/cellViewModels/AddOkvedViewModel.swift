//
//  AddOkvedViewModel.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 02.10.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import Foundation

class AddOkvedViewModel: CellViewModel {

    let okveds: [OKVED]
    
    init(okveds: [OKVED]) {
        self.okveds = okveds
        super.init(title: "Добавить ОКВЭД", text: "", id: "", type: .addOkved)
    }
}
