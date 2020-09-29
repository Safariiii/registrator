//
//  MakeIPTableViewCell.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 15.06.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import UIKit

class MakeIPTableViewCell: UITableViewCell {

    var textField: TextFieldView?
    let pickerButton = UIButton()
    var okvedDelegate: OkvedDelegate?
    var parentViewController: UIViewController?
    lazy var nextButton: UILabel = {
        let label = UILabel(text: "Далее", textColor: .white, alignment: .center, numberOfLines: 1)
        return label
    }()
    lazy var addOkvedsButton: UIButton = {
        let button = UIButton(title: "Добавить ОКВЭДы", titleColor: .black, backgroundColor: .white, action: #selector(addOkvedsButtonPressed), target: self, fontSize: 15)
        return button
    }()
    
    var cellSection: Int = 0
    var cellTag: Int = 0
    var pickerHekper: PickerHelper?
    
    //MARK: - ViewModel
    
    weak var viewModel: MakIPCellViewModel? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            cellTag = viewModel.tag
            cellSection = viewModel.currentSection
            
            setupCell(viewModel: viewModel)
            
            if viewModel.sectionType == .normal {
                setupTextField(viewModel: viewModel)
                setupPickerButtons(viewModel: viewModel)
            }
            switch viewModel.cellType {
            case .normal:
                setupTextLabel(viewModel: viewModel)
            case .addOkvedButton:
                setupAddOkvedsButton()
            case .nextButton:
                setupNextButton()
            }
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func setupCell(viewModel: MakIPCellViewModel) {
        let tableView = self.superview as! UITableView
        parentViewController = tableView.dataSource as? MakeIPViewController
        pickerButton.removeFromSuperview()
        nextButton.removeFromSuperview()
        addOkvedsButton.removeFromSuperview()
        textField?.removeFromSuperview()
        backgroundColor = .white
        accessoryType = viewModel.accessoryType
        translatesAutoresizingMaskIntoConstraints = true
        textField?.text = ""
        textLabel?.text = viewModel.cellTitle
    }
    
    func setupPickerButtons(viewModel: MakIPCellViewModel) {
        switch textField?.type {
        case .sex, .taxesSystem, .taxesRate, .passportDate, .dateOfBirth:
            setupPickerButton()
        default: break
        }
    }
    
    //MARK: - AddOkvedsButton
    func setupAddOkvedsButton() {
        addSubview(addOkvedsButton)
        addOkvedsButton.fillSuperview()
        okvedDelegate = parentViewController as? OkvedDelegate
    }
    
    @objc func addOkvedsButtonPressed() {
        okvedDelegate?.addOkvedsButtonPressed()
    }
    //MARK: - TextField

    func setupTextField(viewModel: MakIPCellViewModel) {
        textField = TextFieldView(viewModel: viewModel)
        if textField?.type != TextFieldType.none {
            addSubview(textField!)
        }
        textField?.delegate = parentViewController as? UITextFieldDelegate
    }
    
    //MARK: - TextLabel
    
    func setupTextLabel(viewModel: MakIPCellViewModel) {
        textLabel?.numberOfLines = 0
        textLabel?.setupAnchors(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 7, bottom: 0, right: -7))
        textLabel?.font = UIFont.systemFont(ofSize: 13)
        if textField?.text == "" {
            textLabel?.transform = CGAffineTransform(translationX: 0, y: 0)
        } else {
            textLabel?.transform = CGAffineTransform(translationX: 0, y: -20)
        }
    }
    
    //MARK: - pickerButton
    
    func setupPickerButton() {
        addSubview(pickerButton)
        pickerButton.fillSuperview()
        switch textField?.type {
        case .sex, .taxesSystem, .taxesRate:
            pickerButton.addTarget(self, action: #selector(pickerButtonPressed), for: .touchUpInside)
        default:
            pickerButton.addTarget(self, action: #selector(datePickerButtonPressed), for: .touchUpInside)
        }
    }
    
    @objc func pickerButtonPressed(sender: UIButton) {
        if let view = parentViewController?.view {
            let pickerView = PickerView(tag: cellTag, section: cellSection)
            
            pickerHekper = PickerHelper(self)
            pickerView.delegate = pickerHekper
            pickerView.dataSource = pickerHekper
            

            pickerView.delegate = parentViewController as? UIPickerViewDelegate
            pickerView.dataSource = parentViewController as? UIPickerViewDataSource
            view.addSubview(pickerView)
        }
    }
    
    @objc func datePickerButtonPressed(sender: UIButton) {
        if let view = parentViewController?.view {
            let delegate = parentViewController as? DatePickerDelegate
            let datePicker = DatePickerView(delegate: delegate!, type: textField?.type)
            view.addSubview(datePicker)
        }
    }
    
    //MARK: - NextButton
    
    func setupNextButton() {
        addSubview(nextButton)
        nextButton.backgroundColor = .red
        nextButton.fillSuperview()
    }
}

extension PickerHelper: UIPickerViewDelegate {
    
}

extension PickerHelper: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 0
    }
}

class PickerHelper: NSObject {
    var view: UIView?
    init(_ view: UIView) {
        super.init()
        
    }
    
}
