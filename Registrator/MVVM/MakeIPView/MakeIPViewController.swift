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
    
    func setupCell(indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = makeIPViewModel else { return UITableViewCell() }
        let step = viewModel.steps
        switch step.fields[indexPath.row].group {
        case .text:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? TextCell else { return UITableViewCell() }
            cell.viewModel = viewModel.cellViewModel(indexPath: indexPath) as? TextCellViewModel
            return cell
        case .picker:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as? PickerCell else { return UITableViewCell() }
            cell.viewModel = viewModel.cellViewModel(indexPath: indexPath) as? PickerCellViewModel
            return cell
        case .datePicker:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell5", for: indexPath) as? DatePickerCell else { return UITableViewCell() }
            cell.viewModel = viewModel.cellViewModel(indexPath: indexPath)
            return cell
        case .giveMethod:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath) as? GiveMethodCell else { return UITableViewCell() }
            cell.tag = indexPath.row
            cell.viewModel = viewModel.cellViewModel(indexPath: indexPath) as? GiveMethodCellViewModel
            return cell
        case .okveds:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell3", for: indexPath) as? OkvedCell else { return UITableViewCell() }
            cell.viewModel = viewModel.cellViewModel(indexPath: indexPath) as? OkvedTypeCellViewModel
            return cell
        case .none:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell4", for: indexPath) as? NextButtonCell else { return UITableViewCell() }
            cell.viewModel = viewModel.cellViewModel(indexPath: indexPath) as? NextButtonViewModel
            return cell
        case .addOkved:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell6", for: indexPath) as? AddOkvedCell else { return UITableViewCell() }
            cell.viewModel = viewModel.cellViewModel(indexPath: indexPath) as? AddOkvedViewModel
            return cell
        }
    }

    func register(type: UITableViewCell.Type) {
        //tableView.register(type, forCellReuseIdentifier: type.)
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TextCell.self, forCellReuseIdentifier: "Cell")
        // tableView.register(TextCell.self, forCellReuseIdentifier: "TextCell")
        tableView.register(PickerCell.self, forCellReuseIdentifier: "Cell1")
        tableView.register(GiveMethodCell.self, forCellReuseIdentifier: "Cell2")
        tableView.register(OkvedCell.self, forCellReuseIdentifier: "Cell3")
        tableView.register(NextButtonCell.self, forCellReuseIdentifier: "Cell4")
        tableView.register(DatePickerCell.self, forCellReuseIdentifier: "Cell5")
        tableView.register(AddOkvedCell.self, forCellReuseIdentifier: "Cell6")
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
            DispatchQueue.main.async {
               self?.tableView.reloadData()
            }
        }
        viewModel.addSatusView = { [weak self] view in
            DispatchQueue.main.async {
                self?.view.addSubview(view)
            }
        }
        viewModel.showStatusAlert = { [weak self] title, message in
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "ok", style: .default) { (action) in
                if title != "Ошибка" {
                    self?.navigationController?.popViewController(animated: true)
                }
            }
            alert.addAction(action)
            self?.present(alert, animated: true, completion: nil)
            
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
            
        }
        UIView.animate(withDuration: keyboardDuration ?? 00) {
            self.view.layoutIfNeeded()
            self.view.removeGestureRecognizer(self.tap!)
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        if let tap = tap {
            print("ok")
            view.removeGestureRecognizer(tap)
            self.tap = nil
        }
        view.endEditing(false)
        
    }
}

extension MakeIPViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let makeIPViewModel = makeIPViewModel else { return UIView() }
        return MakeIpSectionView(viewModel: makeIPViewModel)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let step = makeIPViewModel?.steps else { return 60 }
        if step == .step3 {
            if step.fields[indexPath.row] == .none || step.fields[indexPath.row] == .addOkved {
                return 60
            } else {
                return 80
            }
        } else {
            return 60
        }
        
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
        return setupCell(indexPath: indexPath)
    }
}
