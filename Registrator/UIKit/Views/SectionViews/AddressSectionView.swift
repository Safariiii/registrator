//
//  AddressSectionView.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 07.10.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import UIKit

class AddressSectionView: UIView {
    
    init(type: AddressStep) {
        super.init(frame: .zero)
        heightAnchor.constraint(equalToConstant: 45).isActive = true
        setupTitleLabel(type: type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupTitleLabel(type: AddressStep) {
        var text = ""
        switch type {
        case .search:
            text = "Найденные адреса:"
        case .write:
            text = "Подтвердите адрес:"
        }
        let title = UILabel(text: text, fontSize: 18, alignment: .center, numberOfLines: 1)
        addSubview(title)
        title.fillSuperview()
    }
}
