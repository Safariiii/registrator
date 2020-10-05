//
//  BasicCell.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 30.09.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import UIKit

class BasicCell: UITableViewCell {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        titleLabel?.removeFromSuperview()
        textField?.removeFromSuperview()
        
        titleLabel = TitleLabel()
        addSubview(titleLabel!)
        
    }
    
    var textField: UITextField?
    var titleLabel: TitleLabel?
    
    
    func setupTitleLabel() {
        if let tf = textField {
            if tf.isEmpty {
                titleLabel?.transform = CGAffineTransform(translationX: 0, y: 0)
            } else {
                titleLabel?.transform = CGAffineTransform(translationX: 0, y: -20)
            }
        }
    }
}
