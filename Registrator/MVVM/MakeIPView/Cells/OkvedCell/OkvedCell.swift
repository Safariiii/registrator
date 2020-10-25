//
//  OkvedCell.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 30.09.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import UIKit

class OkvedCell: NotTextFieldCell {
    
    lazy var mainOkvedLabel: UILabel = {
        let label = UILabel(numberOfLines: 0)
        return label
    }()
    
    lazy var mainOkvedSecondLabel: UILabel = {
        let text = """
        Главный
        ОКВЭД
        """
        let label = UILabel(text: text, textColor: .systemGreen, fontSize: 13, fontWeight: .semibold, numberOfLines: 2)
        return label
    }()

    weak var viewModel: OkvedTypeCellViewModel? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            initViewModel(viewModel: viewModel)
        }
    }
    
    func initViewModel(viewModel: OkvedTypeCellViewModel) {
        if viewModel.mainOkved == viewModel.text {
            titleLabel?.text = ""
            setupMainOkvedSecondLabel()
            setupMainOkvedLabel(viewModel: viewModel)
        } else {
            mainOkvedLabel.removeFromSuperview()
            mainOkvedSecondLabel.removeFromSuperview()
            titleLabel?.text = viewModel.text
            titleLabel?.font = UIFont.systemFont(ofSize: 15)
        }
     }

    func setupMainOkvedSecondLabel() {
        addSubview(mainOkvedSecondLabel)
        mainOkvedSecondLabel.setupAnchors(top: topAnchor, leading: nil, bottom: bottomAnchor, trailing: trailingAnchor)
        mainOkvedSecondLabel.widthAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    func setupMainOkvedLabel(viewModel: OkvedTypeCellViewModel) {
        addSubview(mainOkvedLabel)
        mainOkvedLabel.setupAnchors(top: topAnchor, leading: titleLabel?.leadingAnchor, bottom: bottomAnchor, trailing: mainOkvedSecondLabel.leadingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: -6))
        mainOkvedLabel.text = viewModel.text
        
    }
}
