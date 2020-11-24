//
//  AddressSectionView.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 07.10.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

fileprivate let sectionTitile = "Введите адрес"

import UIKit

class AddressSectionView: UIView {
    
    init(type: AddressType) {
        super.init(frame: .zero)
        heightAnchor.constraint(equalToConstant: 45).isActive = true
        setupTitleLabel(type: type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel(fontSize: 18, alignment: .center, numberOfLines: 1)
        return label
    }()

    func setupTitleLabel(type: AddressType) {
        addSubview(titleLabel)
        titleLabel.fillSuperview()
        titleLabel.text = type.rawValue
    }
}
