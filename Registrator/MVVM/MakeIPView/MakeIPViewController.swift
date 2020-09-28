//
//  MakeIPViewController.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 14.06.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import UIKit

class MakeIPViewController: UIViewController {
    
    var makeIPViewModel: MakeIPViewModel? {
        didSet {
            initViewModel()
        }
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MakeIPTableViewCell.self, forCellReuseIdentifier: "Cell")
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupKeyboard()
    }
    
    func initViewModel() {
        guard let viewModel = makeIPViewModel else { return }
        viewModel.reloadHandler = { [weak self] in
            self?.tableView.reloadData()
        }
        if viewModel.isNew {
            let helpView = DocumentView()
            view.addSubview(helpView)
        }
    }
    
    var tableViewBottomAnchor: NSLayoutConstraint?
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.setupAnchors(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor)
        tableViewBottomAnchor = tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        tableViewBottomAnchor?.isActive = true
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    var tap: UITapGestureRecognizer?
    @objc func handleKeyboard(notification: NSNotification) {
        let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        let keyboardDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        if notification.name.rawValue == "UIKeyboardWillShowNotification" {
            tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            view.addGestureRecognizer(tap!)
            tableViewBottomAnchor?.isActive = false
            tableViewBottomAnchor = tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -keyboardFrame!.height)
            tableViewBottomAnchor?.isActive = true
        } else {
            tableViewBottomAnchor?.isActive = false
            tableViewBottomAnchor = tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
            tableViewBottomAnchor?.isActive = true
            view.removeGestureRecognizer(tap!)
        }
        UIView.animate(withDuration: keyboardDuration ?? 00) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension MakeIPViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let makeIPViewModel = makeIPViewModel else { return UIView() }
        return MakeIpSectionView(viewModel: makeIPViewModel)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = makeIPViewModel else { return }
        viewModel.didSelectRow(index: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension MakeIPViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = makeIPViewModel else { return 0}
        return viewModel.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? MakeIPTableViewCell
        guard let tableViewCell = cell, let viewModel = makeIPViewModel else { return UITableViewCell() }
        let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath)
        tableViewCell.viewModel = cellViewModel
        return tableViewCell
    }
}

extension MakeIPViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let viewModel = makeIPViewModel else { return }
        if let text = textField.text, text != "" {
            viewModel.setTextFieldInfo(text: text, type: textField.type)
//            tableView.reloadData()
        } else {
            guard let superview = textField.superview as? MakeIPTableViewCell else { return }
            let indexPath = tableView.indexPath(for: superview)
            if let indexPath = indexPath {
                guard let cell = tableView.cellForRow(at: indexPath) else { return }
                cell.animateCellTextLabel(y: 0)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didUpdateFocusIn context: UITableViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        print("ok")
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let superview = textField.superview as? MakeIPTableViewCell else { return }
        let indexPath = tableView.indexPath(for: superview)
        if let indexPath = indexPath {
            guard let cell = tableView.cellForRow(at: indexPath) else { return }
            cell.animateCellTextLabel(y: -20)
        }
        textField.setupPhoneNumberMask()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return textField.validateTextField(letter: string)
    }
}

extension MakeIPViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let viewModel = makeIPViewModel else { return nil }
        return viewModel.titleForRowInPickerView(row: row, type: pickerView.type)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let viewModel = makeIPViewModel else { return }
        if pickerView.type == .genders {
            viewModel.setTextFieldInfo(text: Constants.genders[row], type: .sex)
        } else if pickerView.type == .taxesSystem {
            viewModel.setTextFieldInfo(text: Constants.taxes[row], type: .taxesSystem)
        } else {
            viewModel.setTextFieldInfo(text: Constants.taxesRate[row], type: .taxesRate)
        }
        tableView.reloadData()
    }
}

extension MakeIPViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
}

extension MakeIPViewController: DatePickerDelegate {
    func didDismissDatePicker(text: String, type: TextFieldType) {
        guard let viewModel = makeIPViewModel else { return }
        viewModel.setTextFieldInfo(text: text, type: type)
        tableView.reloadData()
    }
}

extension MakeIPViewController: OkvedDelegate {
    func addOkvedsButtonPressed() {
        guard let viewModel = makeIPViewModel else { return }
        let okvedView = OkvedView(makeIPviewModel: viewModel)
        view.addSubview(okvedView)
    }
}
