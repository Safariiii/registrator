//
//  OkvedView.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 26.09.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import UIKit

class OkvedView: UIView {
    
    let searchBar = UISearchBar()
    let okvedTableView = UITableView()
    var viewModel: OkvedTableViewViewModel
    let newView = UIView()
    let makeIPviewModel: MakeIPViewModel?
    
    lazy var okvedDoneButton: UIButton = {
        let button = UIButton(title: "Готово", backgroundColor: .red, action: #selector(doneButtonPressed), target: self, cornerRadius: 7)
        button.setSize(width: 220, height: 40)
        return button
    }()
    
    init(makeIPviewModel: MakeIPViewModel) {
        self.viewModel = OkvedTableViewViewModel(okveds: makeIPviewModel.newFile?.okveds ?? [])
        self.makeIPviewModel = makeIPviewModel
        super.init(frame: .zero)
        self.viewModel.reloadHandler = { [weak self] in
            self?.okvedTableView.reloadData()
        }
        self.viewModel.scrollToRow = { indexPath in
            self.okvedTableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }

        addSubview(searchBar)
        searchBar.delegate = self
        searchBar.setupAnchors(top: safeAreaLayoutGuide.topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
        
        addSubview(okvedTableView)
        okvedTableView.setupAnchors(top: searchBar.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        okvedTableView.register(OkvedTableViewCell.self, forCellReuseIdentifier: "okvedTableViewCell")
        okvedTableView.delegate = self
        okvedTableView.dataSource = self
        
        addSubview(okvedDoneButton)
        okvedDoneButton.setupAnchors(top: nil, leading: nil, bottom: safeAreaLayoutGuide.bottomAnchor, trailing: nil, centerX: centerXAnchor, centerY: nil, padding: .init(top: 0, left: 0, bottom: -40, right: 0))
    }
    
    @objc func doneButtonPressed() {
        removeFromSuperview()
    }
    
    override func didMoveToSuperview() {
        fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension OkvedView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return OkvedSectionView(viewModel: viewModel, section: section)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let makeIPviewModel = makeIPviewModel else { return }
        viewModel.didSelectRow(indexPath: indexPath, ipViewModel: makeIPviewModel)
    }
}

extension OkvedView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = okvedTableView.dequeueReusableCell(withIdentifier: "okvedTableViewCell", for: indexPath) as? OkvedTableViewCell
        
        guard let tableViewCell = cell else { return UITableViewCell() }
        let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath)
        tableViewCell.viewModel = cellViewModel
        
        return tableViewCell
    }
}

extension OkvedView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchBarTextDidChange(text: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
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
