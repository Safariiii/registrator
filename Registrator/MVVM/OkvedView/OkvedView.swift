//
//  OkvedView.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 26.09.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import UIKit

class OkvedView: UIViewController {
    
    let searchBar = UISearchBar()
    let okvedTableView = UITableView()
    var viewModel: OkvedTableViewViewModel?
    let newView = UIView()
    var id: String?
    lazy var okvedDoneButton: UIButton = {
        let button = UIButton(title: "Готово", titleColor: .white, backgroundColor: .red, action: #selector(doneButtonPressed), target: self, cornerRadius: 7)
        button.setSize(width: 220, height: 40)
        return button
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
        
    override func viewDidLoad() {
        setupHandlers()
        setupSearchBar()
        setupOkvedTableView()
        setupOkvedDoneButton()
    }
    
    func setupHandlers() {
        guard let viewModel = viewModel else { return }
        viewModel.reloadHandler = { [weak self] in
            self?.okvedTableView.reloadData()
        }
        viewModel.scrollToRow = { indexPath in
            self.okvedTableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
    func setupSearchBar() {
        view.addSubview(searchBar)
        searchBar.delegate = self
        searchBar.setupAnchors(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor)
    }
    
    func setupOkvedTableView() {
        view.addSubview(okvedTableView)
        okvedTableView.setupAnchors(top: searchBar.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        okvedTableView.register(OkvedTableViewCell.self, forCellReuseIdentifier: "okvedTableViewCell")
        okvedTableView.delegate = self
        okvedTableView.dataSource = self
    }
    
    func setupOkvedDoneButton() {
        view.addSubview(okvedDoneButton)
        okvedDoneButton.setupAnchors(top: nil, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: nil, centerX: view.centerXAnchor, centerY: nil, padding: .init(top: 0, left: 0, bottom: -40, right: 0))
    }
    
    @objc func doneButtonPressed() {
        guard let viewModel = viewModel else { return }
        viewModel.dismissVC()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension OkvedView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let viewModel = viewModel else { return UIView() }
        return OkvedSectionView(viewModel: viewModel, section: section)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        viewModel.didSelectRow(indexPath: indexPath)
    }
}

extension OkvedView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.numberOfSections()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = okvedTableView.dequeueReusableCell(withIdentifier: "okvedTableViewCell", for: indexPath) as? OkvedTableViewCell
        
        guard let tableViewCell = cell, let viewModel = viewModel else { return UITableViewCell() }
        let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath)
        tableViewCell.viewModel = cellViewModel
        
        return tableViewCell
    }
}

extension OkvedView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let viewModel = viewModel else { return }
        viewModel.searchBarTextDidChange(text: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            guard let viewModel = viewModel else { return }
            viewModel.searchBarTextDidChange(text: text)
        }
    }
    
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
}
