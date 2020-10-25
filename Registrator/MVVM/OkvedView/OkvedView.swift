//
//  OkvedView.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 26.09.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

fileprivate let searchBarPlaceholder = "Введите ключевые слова для быстрого поиска"
fileprivate var okvedCounterNumber = "Добавлено оквэдов: 0/57"
fileprivate let alertTitle = "Внимание!"
fileprivate let alertMessage = "Максимальное количество кодов ОКВЭД не может превышать 57. Чтобы добавить данный код вам необходимо убрать один из уже добавленных кодов"

import UIKit

class OkvedView: UIViewController {
    
    let searchBar = UISearchBar()
    
    var viewModel: OkvedTableViewViewModel?
    let newView = UIView()
    var id: String?
    lazy var okvedDoneButton: UIButton = {
        let button = UIButton(title: "Готово", titleColor: .black, backgroundColor: .systemGreen, action: #selector(doneButtonPressed), target: self, cornerRadius: 7)
        button.setSize(width: 180, height: 40)
        button.drawShadow()
        button.layer.shadowOffset = CGSize(width: -4.0, height: 7.0)
        button.layer.shadowRadius = 7
        return button
    }()
    
    lazy var okvedTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(OkvedTableViewCell.self, forCellReuseIdentifier: "okvedTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .black
        return tableView
    }()
    
    lazy var okvedCounter: UILabelPadding = {
        let label = UILabelPadding(fontSize: 15, alignment: .center, numberOfLines: 0)
        label.backgroundColor = .systemGreen
        label.setSize(width: 260, height: 40)
        return label
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
        
    override func viewDidLoad() {
        setupHandlers()
        setupSearchBar()
        setupOkvedTableView()
        setupOkvedDoneButton()
        setupOkvedCounter()
        view.backgroundColor = .white
    }
    
    func setupHandlers() {
        guard let viewModel = viewModel else { return }
        viewModel.reloadHandler = { [weak self] in
            self?.okvedTableView.reloadData()
            okvedCounterNumber = "Добавлено оквэдов: \(viewModel.okvedCounter)/57"
            self?.okvedCounter.text = okvedCounterNumber
        }
        viewModel.scrollToRow = { [weak self] indexPath in
            self?.okvedTableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
        viewModel.alertMessage = { [weak self] in
            let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
            let action = UIAlertAction(title: "ok", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(action)
            self?.present(alert, animated: true, completion: nil)
        }
    }
    
    func setupSearchBar() {
        view.addSubview(searchBar)
        searchBar.delegate = self
        searchBar.setupAnchors(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor)
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: searchBarPlaceholder, attributes: [.font : UIFont.systemFont(ofSize: 14)])
        
    }
    
    func setupOkvedTableView() {
        view.addSubview(okvedTableView)
        okvedTableView.setupAnchors(top: searchBar.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        
    }
    
    func setupOkvedDoneButton() {
        view.addSubview(okvedDoneButton)
        okvedDoneButton.setupAnchors(top: nil, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: nil, centerX: view.centerXAnchor, centerY: nil, padding: .init(top: 0, left: 0, bottom: -40, right: 0))
    }
    
    func setupOkvedCounter() {
        guard let viewModel = viewModel else { return }
        view.addSubview(okvedCounter)
        okvedCounter.setupAnchors(top: nil, leading: nil, bottom: okvedDoneButton.topAnchor, trailing: nil, centerX: view.centerXAnchor, padding: .init(top: 0, left: 0, bottom: -20, right: 0))
        okvedCounterNumber = "Добавлено оквэдов: \(viewModel.okvedCounter)/57"
        okvedCounter.text = okvedCounterNumber
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
