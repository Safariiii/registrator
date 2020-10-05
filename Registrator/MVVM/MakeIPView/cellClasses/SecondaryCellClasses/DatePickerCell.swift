//
//  DatePickerCell.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 01.10.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import UIKit

class DatePickerCell: TextFieldCell {

    var viewModel: CellViewModel? {
        willSet(viewModel) {
            titleLabel?.text = viewModel?.title
            textField?.text = viewModel?.text
            textField?.isUserInteractionEnabled = false
            setupPickerButton()
            setupTitleLabel()
        }
    }

    //MARK: - pickerButton
    
    func setupPickerButton() {
        let pickerButton = UIButton()
        addSubview(pickerButton)
        pickerButton.fillSuperview()
        pickerButton.addTarget(self, action: #selector(datePickerButtonPressed), for: .touchUpInside)
    }
    
    @objc func datePickerButtonPressed(sender: UIButton) {
        let tableview = superview as! UITableView
        let vc = tableview.dataSource as? MakeIPViewController
        let datePicker = DatePickerView()
        datePicker.delegate = self
        if let view = vc?.view {
            view.addSubview(datePicker)
        }
    }
}

extension DatePickerCell: DatePickerDelegate {
    func didDismissDatePicker(text: String) {
        guard let viewModel = viewModel else { return }
        viewModel.save(text: text)
    }
}
