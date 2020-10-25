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
        setupSegmentControl()
        setupSearchBar()
        setupTableView()
    }

    
    //MARK: - SegmentControl
    lazy var segmentControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: [firstItemTitle, secondItemTitle])
        sc.selectedSegmentIndex = 0
        sc.heightAnchor.constraint(equalToConstant: 50).isActive = true
        sc.addTarget(self, action: #selector(segmentControlChanged), for: .valueChanged)
        return sc
    }()
    
    func setupSegmentControl() {
        view.addSubview(segmentControl)
        segmentControl.setupAnchors(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor)
    }
    
    @objc func segmentControlChanged(sender: UISegmentedControl) {
        guard let viewModel = viewModel else { return }
        viewModel.changeStep()
        if sender.selectedSegmentIndex == 0 {
            firstSegmentActive()
        } else {
            secondSegmentActive()
        }
    }
    
    func firstSegmentActive() {
        searchBar.isHidden = false
        tableViewTopAnchor?.isActive = false
        tableViewTopAnchor = tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor)
        tableViewTopAnchor?.isActive = true
        tableView.reloadData()
        
    }
    
    func secondSegmentActive() {
        searchBar.isHidden = true
        tableViewTopAnchor?.isActive = false
        tableViewTopAnchor = tableView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor)
        tableViewTopAnchor?.isActive = true
        tableView.reloadData()
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
        tableViewTopAnchor = tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor)
        tableViewTopAnchor?.isActive = true
        tableView.setupAnchors(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
    }
    
    //MARK: - SeacrchBar
    
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.searchTextField.placeholder = searchBarPlaceholder
        sb.delegate = self
        return sb
    }()
    
    func setupSearchBar() {
        view.addSubview(searchBar)
        searchBar.setupAnchors(top: segmentControl.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor)
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
        return AddressSectionView(type: viewModel.step)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        tableView.deselectRow(at: indexPath, animated: true)
        if viewModel.step == .search {
            viewModel.didSelectRowAt(row: indexPath.row)
            if viewModel.dataArr.count == 1 {
                viewModel.parseAddress(text: viewModel.dataArr[0].strValue) { [weak self] in
                    self?.tableView.reloadData()
                }
            }
            segmentControl.selectedSegmentIndex = segmentControl.selectedSegmentIndex == 0 ? 1 : 0
            secondSegmentActive()
        } else {
            viewModel.didSelectRowAt(row: indexPath.row)
            tableView.reloadData()
        }
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
        DispatchQueue.main.async {
            self.searchBar.resignFirstResponder()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let viewModel = viewModel else { return }
        if let text = searchBar.text, text != "" {
            viewModel.getNote(text: searchText) { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
}
