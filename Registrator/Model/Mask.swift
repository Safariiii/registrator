//
//  Mask.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 26.07.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import UIKit

struct Mask {
    
    private func checkForBackspace(letter: String)->Bool {
        if let char = letter.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            return isBackSpace == -92
        } else {
            return false
        }
    }
    
    private func validateMaskForINN(textField: UITextField, letter: String) {
        if !checkForBackspace(letter: letter) {
            if textField.text!.count == 4 {
                textField.text?.insert(contentsOf: " ", at: textField.text!.endIndex)
            } else if textField.text!.count == 9 {
                textField.text?.insert(contentsOf: " ", at: textField.text!.endIndex)
            }
        }
    }
    
    private func validateMaskForSNILS(textField: UITextField, letter: String) {
        if !checkForBackspace(letter: letter) {
            if textField.text!.count == 3 {
                textField.text?.insert(contentsOf: " ", at: textField.text!.endIndex)
            } else if textField.text!.count == 7 {
                textField.text?.insert(contentsOf: " ", at: textField.text!.endIndex)
            } else if textField.text!.count == 11 {
                textField.text?.insert(contentsOf: " ", at: textField.text!.endIndex)
            }
        }
    }
    
    private func validateMaskForPassportCode(textField: UITextField, letter: String) {
        if !checkForBackspace(letter: letter) {
            if textField.text!.count == 3 {
                textField.text?.insert(contentsOf: "-", at: textField.text!.endIndex)
            }
        }
    }
    
    private func validateNumbers(textField: UITextField, letter: String, num: Int) -> Bool {
        while textField.text!.count + 1 <= num {
            if Int(letter) != nil {
                return true
            } else {
                return checkForBackspace(letter: letter)
            }
        }
        return checkForBackspace(letter: letter)
    }
    
    private func validatePhoneNumber(textField: UITextField, letter: String) -> Bool {
        if !checkForBackspace(letter: letter) {
            while textField.text!.count  + 1 < 18 {
                if Int(letter) != nil {
                    if textField.text?.count == 7 {
                        textField.text?.insert(contentsOf: ")", at: textField.text!.endIndex)
                    } else if textField.text?.count == 11 {
                        textField.text?.insert(contentsOf: "-", at: textField.text!.endIndex)
                    } else if textField.text?.count == 14 {
                        textField.text?.insert(contentsOf: "-", at: textField.text!.endIndex)
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
    
    func setupMask(textField: UITextField, tag: Int, section: Int) {
        if section == 0 {
            if textField.tag == 7 {
                if textField.text == "" {
                    textField.text = "+7 ("
                }
            }
        }
        
    }
    
    func validateTextField(textField: UITextField, letter: String, section: Int) -> Bool {
        if section == 0 {
            if textField.tag == 7 {
                return validatePhoneNumber(textField: textField, letter: letter)
            } else {
                return true
            }
        } else {
            if textField.tag == 0 {
                return validateNumbers(textField: textField, letter: letter, num: 4)
            } else if textField.tag == 1 {
                return validateNumbers(textField: textField, letter: letter, num: 6)
            } else if textField.tag == 4 {
                validateMaskForPassportCode(textField: textField, letter: letter)
                return validateNumbers(textField: textField, letter: letter, num: 7)
            } else if textField.tag == 7 {
                validateMaskForINN(textField: textField, letter: letter)
                return validateNumbers(textField: textField, letter: letter, num: 14)
            } else if textField.tag == 8 {
                validateMaskForSNILS(textField: textField, letter: letter)
                return validateNumbers(textField: textField, letter: letter, num: 14)
            } else {
                return true
            }
        }
    }
}
