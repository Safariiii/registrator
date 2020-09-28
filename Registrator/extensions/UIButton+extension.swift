//
//  UIButton+extension.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 24.09.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import UIKit

extension UIButton {
//    
    convenience init(title: String = "", titleColor: UIColor = .black, backgroundColor: UIColor = .clear, action: Selector?, target: Any?, targetEvent: UIControl.Event = .touchUpInside, cornerRadius: CGFloat = 0, tag: Int = 0, fontSize: CGFloat = 17, numberOfLines: Int = 0, textAlignment: NSTextAlignment = .center, image: UIImage? = nil) {
        
        self.init()
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        self.backgroundColor = backgroundColor
        layer.cornerRadius = cornerRadius
        self.tag = tag
        if let action = action {
            addTarget(target, action: action, for: targetEvent)
        }
        if let image = image {
            setImage(image, for: .normal)
        }
        titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        titleLabel?.numberOfLines = numberOfLines
        titleLabel?.textAlignment = textAlignment

    }
}
