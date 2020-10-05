//
//  UILabel+extension.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 24.09.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import UIKit

extension UILabel {
    convenience init(text: String = "", textColor: UIColor = .black, fontSize: CGFloat = 17, fontWeight: UIFont.Weight = .regular, alignment: NSTextAlignment = .left, numberOfLines: Int = 0) {
        self.init()
        self.text = text
        self.textColor = textColor
        self.font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        self.textAlignment = alignment
        self.numberOfLines = numberOfLines
        
    }
    
    func animateLabel(y: CGFloat) {
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1,
            options: .curveLinear,
            animations: {
            self.transform = CGAffineTransform(translationX: 0, y: y)
        })
    }
}
