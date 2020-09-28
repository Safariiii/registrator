//
//  TextFieldView.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 26.09.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import UIKit

class TextFieldView: UITextField {
    
    init(viewModel: MakIPCellViewModel) {
        super.init(frame: .zero)
        section = viewModel.currentSection
        tag = viewModel.tag
        text = viewModel.cellText
    }
    
    override func didMoveToSuperview() {
        setupAnchors(top: superview?.topAnchor, leading: superview?.leadingAnchor, bottom: superview?.bottomAnchor, trailing: superview?.trailingAnchor, padding: .init(top: 15, left: 15, bottom: 0, right: -7))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
