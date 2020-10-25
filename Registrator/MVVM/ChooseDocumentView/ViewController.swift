//
//  ViewController.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 14.06.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import UIKit
import FirebaseFunctions

class ViewController: UIViewController {
    
    var viewModel: ChooseDocumentViewModel?
    var okvedManager = OKVEDManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        okvedManager.checkForUpdates(view: view)
        initViewModel()
        guard let viewModel = viewModel else { return }
        title = viewModel.viewControllerTitle
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ChooseDocumentViewControllerCell.self, forCellReuseIdentifier: "Cell")
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.fillSuperview()
    }
    
    func initViewModel() {
        guard let viewModel = viewModel else { return }
        viewModel.reloadHandler = { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.showDocument(indexPath: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Удалить"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        viewModel.deleteDocument(indexPath: indexPath)
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.numberOfSections() ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRowsInSection() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ChooseDocumentViewControllerCell
        guard let tableViewCell = cell, let viewModel = viewModel else { return UITableViewCell() }
        let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath)
        tableViewCell.viewModel = cellViewModel
        
        return tableViewCell
    }
}
