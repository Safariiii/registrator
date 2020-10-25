//
//  TextCell.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 30.09.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import UIKit

class TextCell: TextFieldCell {
    
    var viewModel: TextCellViewModel? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            initViewModel(viewModel: viewModel)
        }
    }
    
    func initViewModel(viewModel: TextCellViewModel) {
        textField?.text = viewModel.text
        titleLabel?.text = viewModel.title
        textField?.delegate = self
        if let note = viewModel.type.note {
            setupNotes()
            noteLabel?.text = note
        }
        if viewModel.type == .citizenship {
            textField?.isUserInteractionEnabled = false
            textField?.text = "РФ"
        } else if viewModel.type == .address {
            textField?.isUserInteractionEnabled = false
        }
        setupTitleLabel()
    }
    
    override func prepareForReuse() {
        note?.removeFromSuperview()
        noteLabel?.removeFromSuperview()
        textField?.isUserInteractionEnabled = true
    }
}

extension TextCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let viewModel = viewModel else { return }
        if let text = textField.text {
            viewModel.save(text: text)
            setupTitleLabel()
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        titleLabel?.animateLabel(y: -20)
        guard let viewModel = viewModel else { return }
        if let text = viewModel.placeholder {
            textField.attributedPlaceholder = NSAttributedString(string: text, attributes: [.font : UIFont.systemFont(ofSize: 14)])
        }
        if viewModel.type == .phoneNumber {
            textField.setupPhoneNumberMask()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let viewModel = viewModel else { return true }
        return textField.validateTextField(letter: string, validateType: viewModel.validateType)
    }
}
