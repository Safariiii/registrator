//
//  TextFieldCell.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 30.09.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import UIKit

class TextFieldCell: BasicCell {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        pickerView?.removeFromSuperview()
        textField = TextFieldView()
        addSubview(textField!)
    }
    
    var pickerView: UIPickerView?
}
