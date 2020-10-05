//
//  PickerCell.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 30.09.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import UIKit

class PickerCell: TextFieldCell {
    var viewModel: PickerCellViewModel? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            titleLabel?.text = viewModel.title
            textField?.text = viewModel.text
            textField?.isUserInteractionEnabled = false
            setupTitleLabel()
            setupPickerButton()
        }
    }

    //MARK: - pickerButton
    
    func setupPickerButton() {
        let pickerButton = UIButton()
        addSubview(pickerButton)
        pickerButton.fillSuperview()
        pickerButton.addTarget(self, action: #selector(pickerButtonPressed), for: .touchUpInside)
    }
    
    @objc func pickerButtonPressed(sender: UIButton) {
        pickerView = PickerView()
        guard let pickerView = pickerView else { return }
        pickerView.delegate = self
        pickerView.dataSource = self
        let tableview = superview as! UITableView
        let vc = tableview.dataSource as? MakeIPViewController
        if let view = vc?.view {
            view.addSubview(pickerView)
        }
    }
}

extension PickerCell: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let viewModel = viewModel else { return nil }
        return viewModel.titleForRowInPickerView(row: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let viewModel = viewModel else { return }
        viewModel.save(text: viewModel.fields[row])
        textField?.text = viewModel.fields[row]
    }
}

extension PickerCell: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.numberOfRowsInComponent()
    }
}
