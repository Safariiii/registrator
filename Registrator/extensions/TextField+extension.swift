//
//  TextField+extension.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 23.09.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import UIKit

extension UITextField {
    
    private struct Position {
        static var section: Int = 0
    }
    
    var section: Int {
        get {
            return Position.section
        }
        set {
            Position.section = newValue
        }
    }
        
    var type: TextFieldType {
        if section == 0 {
            switch tag {
                case 0: return .lastName
                case 1: return .firstName
                case 2: return .middleName
                case 3: return .sex
                case 4: return .citizenship
                case 5: return .dateOfBirth
                case 6: return .email
                case 7: return .phoneNumber
                default: return .none
            }
        } else if section == 1 {
            switch tag {
                case 0: return .passportSeries
                case 1: return .passportNumber
                case 2: return .passportDate
                case 3: return .passportGiver
                case 4: return .passportCode
                case 5: return .placeOfBirth
                case 6: return .address
                case 7: return .inn
                case 8: return .snils
                default: return .none
            }
        } else if section == 3 {
            switch tag {
                case 0: return .taxesSystem
                case 1: return .taxesRate
                default: return .none
            }
        }
        return .none
    }
    
    private func isInLimit(word: String, num: Int) -> Bool {
        while self.text!.count + 1 <= num {
            if Int(word) != nil {
                return true
            } else {
                return word.isBackspace
            }
        }
        return word.isBackspace
    }
    
    private func validateINN(letter: String) -> Bool {
        if !letter.isBackspace {
            if self.text?.count == 4 {
                self.text?.insert(contentsOf: " ", at: self.text!.endIndex)
            } else if self.text?.count == 9 {
                self.text?.insert(contentsOf: " ", at: self.text!.endIndex)
            }
        }
        return isInLimit(word: letter, num: 14)
    }
    
    private func validateSNILS(letter: String) -> Bool {
        if !letter.isBackspace {
            if self.text!.count == 3 {
                self.text?.insert(contentsOf: " ", at: self.text!.endIndex)
            } else if self.text!.count == 7 {
                self.text?.insert(contentsOf: " ", at: self.text!.endIndex)
            } else if self.text!.count == 11 {
                self.text?.insert(contentsOf: " ", at: self.text!.endIndex)
            }
        }
        return isInLimit(word: letter, num: 14)
    }
    
    private func validatePassportCode(letter: String) -> Bool {
        if !letter.isBackspace {
            if self.text!.count == 3 {
                self.text?.insert(contentsOf: "-", at: self.text!.endIndex)
            }
        }
        return isInLimit(word: letter, num: 7)
    }
    
    private func validatePhoneNumber(letter: String) -> Bool {
        if !letter.isBackspace {
            while self.text!.count  + 1 < 17 {
                if Int(letter) != nil {
                    if self.text?.count == 0 {
                        self.text?.insert(contentsOf: "+", at: self.text!.endIndex)
                    } else if self.text?.count == 1 {
                        self.text?.insert(contentsOf: "7", at: self.text!.endIndex)
                    } else if self.text?.count == 2 {
                        self.text?.insert(contentsOf: "(", at: self.text!.endIndex)
                    } else if self.text?.count == 6 {
                        self.text?.insert(contentsOf: ")", at: self.text!.endIndex)
                    } else if self.text?.count == 10 {
                        self.text?.insert(contentsOf: "-", at: self.text!.endIndex)
                    } else if self.text?.count == 13 {
                        self.text?.insert(contentsOf: "-", at: self.text!.endIndex)
                    }
                    return true
                } else {
                    return false
                }
            }
        } else {
            return true
        }
        return false
    }
    
    func setupPhoneNumberMask() {
        if type == .phoneNumber {
            if text == "" {
                text = "+7("
            }
        }
    }
    
    func validateTextField(letter: String) -> Bool {
        switch type {
        case .phoneNumber:
            return validatePhoneNumber(letter: letter)
        case .passportSeries:
            return isInLimit(word: letter, num: 4)
        case .passportNumber:
            return isInLimit(word: letter, num: 6)
        case .passportCode:
            return validatePassportCode(letter: letter)
        case .inn:
            return validateINN(letter: letter)
        case .snils:
            return validateSNILS(letter: letter)
        default:
            return true
        }
    }
}

enum ValidateType {
    case none
    case passport
    case email
    case phone
    
    var validator: Validator? {
        switch self {
        case .passport:
            return PassportValidator()
        case .email:
            return EmailValidator()
        case .phone, .none:
            return nil
        }
    }
}

protocol Validator {
    var type: ValidateType { get }
    func isValide(value: Any) -> Bool
}

struct EmailValidator: Validator {
    var type: ValidateType {
        .email
    }
    
    func isValide(value: Any) -> Bool {
        return true
    }
}

struct PassportValidator: Validator {
    var type: ValidateType {
        .passport
    }
    
    func isValide(value: Any) -> Bool {
        return true
    }
}

//enum TextFieldType {
//    case lastName
//    case firstName
//    case middleName
//    case sex
//    case citizenship
//    case dateOfBirth
//    case email
//    case phoneNumber
//    case passportSeries
//    case passportNumber
//    case passportDate
//    case passportGiver
//    case passportCode
//    case placeOfBirth
//    case address
//    case inn
//    case snils
//    case taxesSystem
//    case taxesRate
//    case giveMethod
//    case okveds
//    case none
//}
