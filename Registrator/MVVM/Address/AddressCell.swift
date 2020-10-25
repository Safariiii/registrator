//
//  AddressCell.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 07.10.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import UIKit

class AddressCell: TextFieldCell {
    
    var viewModel: AddressCellViewModel? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            initViewModel(viewModel: viewModel)
        }
    }
    
    func initViewModel(viewModel: AddressCellViewModel) {
        textField?.isUserInteractionEnabled = false
        backgroundColor = .white
        note?.removeFromSuperview()
        if viewModel.step == .search {
            titleLabel?.text = ""
            textField?.text = ""
            textLabel?.text = viewModel.text
            textLabel?.numberOfLines = 0
        } else {
            textLabel?.text = ""
            textField?.text = viewModel.text
            titleLabel?.text = viewModel.title
            textField?.delegate = self
            setupTitleLabel()
        }
        setupSaveButton(viewModel: viewModel)
        if let note = viewModel.note {
            setupNotes()
            noteLabel?.text = note
        }
        setupArea(viewModel: viewModel)
    }
    
    func setupSaveButton(viewModel: AddressCellViewModel) {
        if viewModel.type == .save {
            titleLabel?.textAlignment = .center
            backgroundColor = .systemGreen
            titleLabel?.font = UIFont.systemFont(ofSize: 18)
            textField?.isUserInteractionEnabled = false
        }
    }
    
    func setupArea(viewModel: AddressCellViewModel) {
        guard let text = textField?.text else { return }
        if viewModel.type == .area {
            if !viewModel.isAreaNeed {
                let strokeEffect: [NSAttributedString.Key : Any] = [
                    NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue,
                ]
                textField?.attributedText = NSAttributedString(string: text, attributes: strokeEffect)
            }
        }
    }
}

extension AddressCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        titleLabel?.animateLabel(y: -20)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        setupTitleLabel()
    }
}
