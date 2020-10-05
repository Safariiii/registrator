//
//  NextButtonViewModel.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 30.09.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import Foundation

class NextButtonViewModel: CellViewModel {
    weak var cell: NextButtonCell?
    
    init() {
        super.init(title: "Далее", text: "", id: "", type: .none)
    }
    
    deinit {
        print("deinit NextButtonViewModel")
    }
    
}
