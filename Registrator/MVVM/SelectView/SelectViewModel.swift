//
//  SelectViewModel.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 06.10.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import Foundation

class SelectViewModel {
    var router: SelectRouter!
    
    func makeDocButtonPressed(tag: Int) {
        router.chooseDocumentRoute(type: DocType.allCases[tag])
    }
    
    func deleteIpButtonPressed() {
        router.chooseDocumentRoute(type: .deleteIP)
    }
    
    func goToLoginView() {
        router.loginRoute()
    }
    
    func createButtons(action: @escaping((_ title: String, _ position: DocType.PositionInSelectView) -> Void)) {
        for item in DocType.allCases {
            action(item.title, item.position)
        }
    }
}
