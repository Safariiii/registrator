//
//  LoginViewModel.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 24.10.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import Foundation
import Firebase

class LoginViewModel {
    var router: LoginRouter!
    
    func loginButtonPressed(title: String, login: String, password: String, errorHandler: @escaping((String) -> Void)) {
        if title == "Регистрация" {
            Auth.auth().createUser(withEmail: login, password: password) { authResult, error in
                if let e = error {
                    var text = "Ошибка"
                    if e.localizedDescription == "The email address is already in use by another account." {
                        text = "Пользователь с таким адресом электронной почты уже зарегистрирован."
                    } else if e.localizedDescription == "The email address is badly formatted." {
                        text = "Неправильный формат адреса электронной почты."
                    } else if e.localizedDescription == "The password must be 6 characters long or more." {
                        text = "Пароль должен содержать не менее 6-ти символов."
                    } else if e.localizedDescription == "An email address must be provided." {
                        text = "Укажите адрес электронной почты"
                    }
                    errorHandler(text)
                } else {
                    self.router.dismissModule()
                    self.saveNewUser(email: login)
                    Auth.auth().currentUser?.sendEmailVerification { (error) in
                        if let e = error {
                            print(e)
                        }
                    }
                }
            }
        } else if title == "Авторизация" {
            Auth.auth().signIn(withEmail: login, password: password) { authResult, error in
                if error != nil {
                    errorHandler("Неправильно введен логин или пароль.")
                } else {
                    self.router.dismissModule()
                }
            }
        }
    }
    
    func saveNewUser(email: String) {
        let db = Firestore.firestore()
        db.collection("Users").document(email).setData(["email": email, "id": UUID().uuidString])
    }
}
