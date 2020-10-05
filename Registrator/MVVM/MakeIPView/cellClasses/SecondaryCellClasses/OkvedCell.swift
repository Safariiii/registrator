//
//  OkvedCell.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 30.09.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import UIKit

class OkvedCell: NotTextFieldCell {

    weak var viewModel: OkvedTypeCellViewModel? {
        willSet(viewModel) {
            titleLabel?.text = viewModel?.text
        }
    }

}
