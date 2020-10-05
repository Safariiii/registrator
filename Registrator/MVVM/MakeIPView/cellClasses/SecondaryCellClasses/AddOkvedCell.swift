//
//  AddOkvedCell.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 02.10.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import UIKit

class AddOkvedCell: UITableViewCell {

    weak var viewModel: AddOkvedViewModel? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            textLabel?.text = viewModel.title
            textLabel?.textAlignment = .center
        }
    }

}
