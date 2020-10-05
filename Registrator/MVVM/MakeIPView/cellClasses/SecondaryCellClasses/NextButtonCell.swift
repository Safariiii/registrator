//
//  NextButtonCell.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 30.09.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import UIKit

class NextButtonCell: UITableViewCell {
    
    //weak
    var viewModel: NextButtonViewModel? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            textLabel?.text = viewModel.title
            backgroundColor = .red
            textLabel?.textColor = .white
            textLabel?.textAlignment = .center
        }
    }
}
