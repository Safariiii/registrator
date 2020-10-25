//
//  UILabelPadding.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 06.10.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import UIKit

class UILabelPadding: UILabel {

    let padding = UIEdgeInsets(top: 10, left: 9, bottom: 12, right: 9)
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override var intrinsicContentSize : CGSize {
        let superContentSize = super.intrinsicContentSize
        let width = superContentSize.width + padding.left + padding.right
        let heigth = superContentSize.height + padding.top + padding.bottom
        return CGSize(width: width, height: heigth)
    }
    
    func drawShadow() {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 8
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: -1.5, height: 3.0)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 3
    }
}
