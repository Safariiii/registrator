//
//  TextField+extension.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 23.09.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import UIKit

extension UITextField {
    
    var isEmpty: Bool {
        if text == "" {
            return true
        } else {
            return false
        }
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
            if self.text!.count  + 1 < 17 {
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
        if text == "" {
            text = "+7("
        }
    }
    
    

    func validateTextField(letter: String, validateType: ValidateType) -> Bool {
        switch validateType {
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

