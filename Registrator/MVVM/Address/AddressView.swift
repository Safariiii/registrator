//
//  AddressView.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 07.10.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

fileprivate let cellID = "addressCell"
fileprivate let searchBarPlaceholder = "Начните вводить адрес"
fileprivate let firstItemTitle = "Найти адрес"
fileprivate let secondItemTitle = "Подтвердить адрес"

import UIKit

class AddressView: UIViewController {
    let extraLayer = UIView()
    let newView = UIView()
    var viewModel: AddressVeiwModel?
    var tableViewTopAnchor: NSLayoutConstraint?
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        setupTableView()
        initViewModel()
    }
    
    func initViewModel() {
        guard let viewModel = viewModel else { return }

    }

    
    
    //MARK: - TableView
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.register(AddressCell.self, forCellReuseIdentifier: cellID)
        tv.tableFooterView = UIView()
        return tv
    }()
    
    func setupTableView() {
        view.addSubview(tableView)
        tableViewTopAnchor = tableView.topAnchor.constraint(equalTo: view.topAnchor)
        tableViewTopAnchor?.isActive = true
        tableView.setupAnchors(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
    }
    
    //MARK:  - PickerView
    var pickerView: PickerView {
        let picker = PickerView()
        picker.delegate = self
        picker.dataSource = self
        return picker
    }
    
}

extension AddressView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.numberOfRows
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel, let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? AddressCell else { return UITableViewCell() }
        cell.viewModel = viewModel.cellViewModel(for: indexPath)
        return cell
    }
}

extension AddressView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let viewModel = viewModel else { return UIView() }
        return AddressSectionView(type: viewModel.fields[section])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        viewModel.addressType = AddressType.allCases[indexPath.row]
        view.addSubview(pickerView)
    }
}

extension AddressView: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.superview?.addSubview(newView)
        newView.fillSuperview()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        newView.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        newView.removeFromSuperview()

    }
}

extension AddressView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        guard let viewModel = viewModel else { return UIView() }
        let label = UILabel(text: viewModel.titleForRowInPickerView(row: row), fontSize: 21, alignment: .center)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5

        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let viewModel = viewModel else { return }
        viewModel.didSelectRowInPickerView(row: row) { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

extension AddressView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.numberOfRowsInComponent
    }
}
