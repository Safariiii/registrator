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
            initViewModel(viewModel: viewModel)
        }
    }
    
    func initViewModel(viewModel: PickerCellViewModel) {
        note?.removeFromSuperview()
        pickerButton.isUserInteractionEnabled = true
        textField?.font = UIFont.systemFont(ofSize: 17)
        titleLabel?.text = viewModel.title
        textField?.text = viewModel.text
        textField?.isUserInteractionEnabled = false
        if viewModel.canShowTaxRate {
            setupPickerButton()
        } else {
            pickerButton.isUserInteractionEnabled = false
            textField?.text = "Доступно только при выборе УСН"
        }
        if viewModel.type == .taxesSystem  {
            textField?.font = UIFont.systemFont(ofSize: 14)
            setupNotes()
            note?.removeTarget(self, action: #selector(notePressed), for: .touchUpInside)
            note?.addTarget(self, action: #selector(setupNoteView), for: .touchUpInside)
        }
        setupTitleLabel()
    }

    //MARK: - pickerButton
    let pickerButton = UIButton()
    func setupPickerButton() {
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
    
    //MARK: - noteView
    @objc func setupNoteView() {
        let noteView = NoteView()
        let tableview = superview as! UITableView
        let vc = tableview.dataSource as? MakeIPViewController
        if let view = vc?.view {
            view.addSubview(noteView)
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
