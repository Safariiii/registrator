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
            initViewModel(viewModel)
        }
    }
    //тут мы создаем UI
    override func awakeFromNib() {
        super.awakeFromNib()
        textField?.isUserInteractionEnabled = false
        setupPickerButton()
    }
    // заполняем
    func initViewModel(_ viewModel: CellViewModel?) {
        titleLabel?.text = viewModel?.title
        textField?.text = viewModel?.text
        
        //setupPickerButton()
        setupTitleLabel()
    }

    // очистить старые данные
    override func prepareForReuse() {
        // запускается перед переиспользованием
        
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
