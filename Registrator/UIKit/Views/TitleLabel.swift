//
//  TitleLabel.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 30.09.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import UIKit

class TitleLabel: UILabel {
    init() {
        super.init(frame: .zero)
        numberOfLines = 0
        font = UIFont.systemFont(ofSize: 13)
    }
    
    override func didMoveToSuperview() {
        setupAnchors(top: superview?.topAnchor, leading: superview?.leadingAnchor, bottom: superview?.bottomAnchor, trailing: superview?.trailingAnchor, padding: .init(top: 0, left: 7, bottom: 0, right: -7))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
