//
//  MakeIPTableViewCell.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 15.06.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import UIKit

class MakeIPTableViewCell: UITableViewCell {

    let textField = UITextField()
    let pickerView = UIPickerView()
    let sexButton = UIButton()
    var vcView: UIView?
    let animations = Animations()
    let extraLayer = UIView()
    let datePicker = UIDatePicker()
    var delegate: DatePickerDelegate?
    var buttonsDelegate: PrevNextButtonsDelegate?
    let nextButton = UIButton()
    var okvedDelegate: OkvedDelegate?
    
    //MARK: - ViewModel
    
    weak var viewModel: MakIPCellViewModel? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            textField.removeFromSuperview()
            sexButton.removeFromSuperview()
            nextButton.removeFromSuperview()
            addOkvedsButton.removeFromSuperview()
            backgroundColor = .white
            translatesAutoresizingMaskIntoConstraints = true
            textLabel?.text = ""
            textLabel?.numberOfLines = 0
            textLabel?.text = viewModel.cellTitle
            accessoryType = .none
            if viewModel.currentSection == 4 {
                accessoryType = viewModel.giveMethod == textLabel?.text ? .checkmark : .none
            }
            vcView = viewModel.viewController.view
            if viewModel.currentSection == 0 || viewModel.currentSection == 1 || viewModel.currentSection == 3 {
                textField.delegate = viewModel.viewController as? UITextFieldDelegate
                setupTextField()
                textField.tag = viewModel.cellIndexPath.row
                textField.text = ""
                textField.text = viewModel.cellText
                pickerView.tag = viewModel.cellIndexPath.row
            } else {
                textField.text = ""
            }
            setupDelegates(viewModel: viewModel)
            if viewModel.cellTitle == "Кнопка добавить ОКВЭД" {
                setupAddOkvedsButton()
            } else if viewModel.cellTitle != "" {
                setupTextLabel()
            } else {
                setupNextButton()
            }
        }
    }
    
    func setupDelegates(viewModel: MakIPCellViewModel) {
        if textLabel?.text == Constants.sex {
            pickerView.delegate = viewModel.viewController as? UIPickerViewDelegate
            pickerView.dataSource = viewModel.viewController as? UIPickerViewDataSource
            setupPickerButton(handler: "Picker")
        } else if textLabel?.text == Constants.passportDate {
            delegate = viewModel.viewController as? DatePickerDelegate
            datePicker.datePickerMode = .date
            setupPickerButton(handler: "Date")
        } else if textLabel?.text == Constants.dateOfBirth {
            delegate = viewModel.viewController as? DatePickerDelegate
            datePicker.datePickerMode = .date
            setupPickerButton(handler: "Date")
        } else if textLabel?.text == "" {
            buttonsDelegate = viewModel.viewController as? PrevNextButtonsDelegate
        } else if textLabel?.text == Constants.tax {
            pickerView.delegate = viewModel.viewController as? UIPickerViewDelegate
            pickerView.dataSource = viewModel.viewController as? UIPickerViewDataSource
            setupPickerButton(handler: "Picker")
        } else if textLabel?.text == Constants.taxRate {
            pickerView.delegate = viewModel.viewController as? UIPickerViewDelegate
            pickerView.dataSource = viewModel.viewController as? UIPickerViewDataSource
            setupPickerButton(handler: "Picker")
        }
        okvedDelegate = viewModel.viewController as? OkvedDelegate
    }
    
    
    //MARK: - AddOkvedsButton
    
    let addOkvedsButton = UIButton()
    
    func setupAddOkvedsButton() {
        addSubview(addOkvedsButton)
        addOkvedsButton.translatesAutoresizingMaskIntoConstraints = false
        addOkvedsButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        addOkvedsButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        addOkvedsButton.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        addOkvedsButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        addOkvedsButton.backgroundColor = .white
        addOkvedsButton.setTitle("Добавить ОКВЭДы", for: .normal)
        addOkvedsButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        addOkvedsButton.titleLabel?.numberOfLines = 0
        addOkvedsButton.titleLabel?.textAlignment = .center
        addOkvedsButton.setTitleColor(.black, for: .normal)
        addOkvedsButton.addTarget(self, action: #selector(addOkvedsButtonPressed), for: .touchUpInside)
    }
    
    @objc func addOkvedsButtonPressed() {
        okvedDelegate?.addOkvedsButtonPressed()
    }
    //MARK: - TextField

    func setupTextField() {
        addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.topAnchor.constraint(equalTo: topAnchor, constant: 15).isActive = true
        textField.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -7).isActive = true
        textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        textField.isHidden = false
    }
    
    //MARK: - TextLabel
    
    func setupTextLabel() {
        textLabel?.translatesAutoresizingMaskIntoConstraints = false
        textLabel?.topAnchor.constraint(equalTo: topAnchor).isActive = true
        textLabel?.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 7).isActive = true
        textLabel?.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 7).isActive = true
        textLabel?.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        textLabel?.font = UIFont.systemFont(ofSize: 13)
        
        if textField.text == "" {
            textLabel?.transform = CGAffineTransform(translationX: 0, y: 0)
        } else {
            textLabel?.transform = CGAffineTransform(translationX: 0, y: -20)
        }
    }
    
    //MARK: - SexButton
    
    func setupPickerButton(handler: String) {
        addSubview(sexButton)
        sexButton.translatesAutoresizingMaskIntoConstraints = false
        sexButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        sexButton.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        sexButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        sexButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        if handler == "Picker" {
            sexButton.addTarget(self, action: #selector(sexButtonPressed), for: .touchUpInside)
        } else if handler == "Date" {
            sexButton.addTarget(self, action: #selector(datePickerButtonPressed), for: .touchUpInside)
        }
    }
    
    @objc func sexButtonPressed(sender: UIButton) {
        if let view = vcView {
            setupPickerView(view: view, pickerView: pickerView, handler: "Picker")
        }
    }
    
    @objc func datePickerButtonPressed(sender: UIButton) {
        if let view = vcView {
            setupDatePicker(view: view)
        }
    }
    
    //MARK: - PickerView
    
    func setupPickerView(view: UIView, pickerView: UIView, handler: String) {
        addExtraLayer(view: view, handler: handler)
        view.addSubview(pickerView)
        extraLayer.alpha = 0.5
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.topAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        pickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        pickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        pickerView.backgroundColor = .white
        pickerView.alpha = 1
        animations.animatePickerView(pickerView: pickerView, y: -pickerView.frame.height)
    }
    
    func setupDatePicker(view: UIView) {
        if let view = vcView {
            setupPickerView(view: view, pickerView: datePicker, handler: "Date")
        }
    }
    
    func addExtraLayer(view: UIView, handler: String) {
        view.addSubview(extraLayer)
        extraLayer.translatesAutoresizingMaskIntoConstraints = false
        extraLayer.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        extraLayer.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        extraLayer.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        extraLayer.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        extraLayer.backgroundColor = .lightGray
        if handler == "Picker" {
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissPickerView))
            extraLayer.addGestureRecognizer(tap)
        } else if handler == "Date" {
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissDatePickerView))
            extraLayer.addGestureRecognizer(tap)
        }
    }
    
    @objc func dismissPickerView() {
        animations.animatePickerView(pickerView: pickerView, y: 0)
        extraLayer.removeFromSuperview()
        pickerView.removeFromSuperview()
    }
    @objc func dismissDatePickerView() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        animations.animatePickerView(pickerView: datePicker, y: 0)
        extraLayer.removeFromSuperview()
        datePicker.removeFromSuperview()
        
        if textLabel?.text == Constants.dateOfBirth {
            delegate?.didDismissDatePicker(text: formatter.string(from: datePicker.date), index: 5)
        } else {
            delegate?.didDismissDatePicker(text: formatter.string(from: datePicker.date), index: 2)
        }
    }
    
    //MARK: - NextButton
    
    func setupNextButton() {
        addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        nextButton.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        nextButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        nextButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        nextButton.setTitle("Далее", for: .normal)
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.backgroundColor = .red
        nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
    }
    
    @objc func nextButtonPressed(sender: UIButton) {
        buttonsDelegate?.prevNextButtonPressed(sender: sender)
    }
}
