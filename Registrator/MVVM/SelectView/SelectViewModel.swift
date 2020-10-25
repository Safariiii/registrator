//
//  SelectViewModel.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 06.10.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import Foundation
import FirebaseAuth

class SelectViewModel {
    var router: SelectRouter!
    
    func makeIpButtonPressed() {
        router.chooseDocumentRoute(type: .makeIP)
    }
    
    func deleteIpButtonPressed() {
        router.chooseDocumentRoute(type: .deleteIP)
    }
    
    func goToLoginView() {
        router.loginRoute()
    }
    
    func logoutButtonPressed() {
        do {
            try Auth.auth().signOut()
            goToLoginView()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}
