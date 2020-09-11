//
//  ViewController.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 14.06.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let makeIPButton = UIButton()
    var ipManagerID: String?
    let tableView = UITableView()
    var viewModel: ChooseDocumentViewModel?
    
    var okvedManager = OKVEDManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeIPButton.layer.cornerRadius = 8
        setupTableView()
        okvedManager.checkForUpdates(view: view)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        ipManagerID = UUID().uuidString
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ChooseDocumentViewControllerCell.self, forCellReuseIdentifier: "Cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "makeIP" {
            let destinationVC = segue.destination as! MakeIPViewController
            destinationVC.isNew = true
            destinationVC.documentID = ipManagerID
        } else if segue.identifier == "openIP" {
            let destinationVC = segue.destination as! MakeIPViewController
            destinationVC.isNew = false
            destinationVC.documentID = viewModel?.documents[(viewModel?.chosenDocument)!].id
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        headerView.backgroundColor = .red
        let title = UILabel()
        title.text = viewModel?.titleForHeaderInSection()
        title.textColor = .white
        headerView.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.topAnchor.constraint(equalTo: headerView.topAnchor).isActive = true
        title.leadingAnchor.constraint(equalTo: headerView.leadingAnchor).isActive = true
        title.trailingAnchor.constraint(equalTo: headerView.trailingAnchor).isActive = true
        title.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        title.textAlignment = .center
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.showDocument(indexPath: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
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
        let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath, documents: viewModel.documents)
        tableViewCell.viewModel = cellViewModel
        
        return tableViewCell
    }
}
