//
//  OkvedTableViewCell.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 12.08.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import UIKit

class OkvedTableViewCell: UITableViewCell {
    
    weak var viewModel: OkvedCellViewModel? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            textLabel?.text = viewModel.text
            backgroundColor = viewModel.backgroundColor
            setupTextLabel()
        }
    }
    
    func setupTextLabel() {
        textLabel?.numberOfLines = 0
        textLabel?.font = UIFont.systemFont(ofSize: 15)
    }
}
