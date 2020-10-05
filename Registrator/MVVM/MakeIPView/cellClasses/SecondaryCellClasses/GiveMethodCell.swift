//
//  GiveMethodCell.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 30.09.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import UIKit

class GiveMethodCell: NotTextFieldCell {
    weak var viewModel: GiveMethodCellViewModel? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            titleLabel?.text = viewModel.title
            accessoryType = titleLabel?.text == viewModel.giveMethod ? .checkmark : .none
        }
    }

}
