//
//  MakeIPViewController.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 14.06.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import UIKit

class MakeIPViewController: UIViewController {
    
    let tableView = UITableView()
    var makeIPViewModel: MakeIPViewModel?
    let animations = Animations()
    let mask = Mask()
    var isNew: Bool?
    let documentMaster = DocumentMaster()
    var okvedTableViewViewModel:OkvedTableViewViewModel?
    var openSection: Int?
    let newView = UIView()
    let okvedTableView = UITableView()
    let okvedMainView = UIView()
    let okvedDoneButton = UIButton()
    let searchBar = UISearchBar()
    
    var documentID: String? {
        didSet {
            if let isnew = isNew {
                makeIPViewModel = MakeIPViewModel(id: documentID!, isNew: isnew, tableView: tableView, viewController: self)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        if isNew ?? true {
            documentMaster.setupHelpView(parentView: view)
        }
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MakeIPTableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

extension MakeIPViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == self.tableView {
            guard let makeIPViewModel = makeIPViewModel else { return UIView()}
            let sectionView = UIView()
            sectionView.backgroundColor = .red
            sectionView.heightAnchor.constraint(equalToConstant: 48).isActive = true
            
            let sectionTitle = UIButton()
            sectionView.addSubview(sectionTitle)
            sectionTitle.translatesAutoresizingMaskIntoConstraints = false
            sectionTitle.topAnchor.constraint(equalTo: sectionView.topAnchor).isActive = true
            sectionTitle.leadingAnchor.constraint(equalTo: sectionView.leadingAnchor).isActive = true
            sectionTitle.trailingAnchor.constraint(equalTo: sectionView.trailingAnchor).isActive = true
            sectionTitle.bottomAnchor.constraint(equalTo: sectionView.bottomAnchor).isActive = true
            
            sectionTitle.setTitle(makeIPViewModel.titleForHeaderInSection(section: section), for: .normal)
            sectionTitle.setTitleColor(.white, for: .normal)
            sectionTitle.tag = section
            
            if makeIPViewModel.currentSection != 0 {
                let prevButton = UIButton()
                sectionView.addSubview(prevButton)
                prevButton.translatesAutoresizingMaskIntoConstraints = false
                prevButton.topAnchor.constraint(equalTo: sectionView.topAnchor).isActive = true
                prevButton.bottomAnchor.constraint(equalTo: sectionView.bottomAnchor).isActive = true
                prevButton.leadingAnchor.constraint(equalTo: sectionView.leadingAnchor, constant: 15).isActive = true
                prevButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
                prevButton.tintColor = .white
                prevButton.addTarget(self, action: #selector(prevButtonPressed), for: .touchUpInside)
            }
            
            if makeIPViewModel.currentSection != 4 {
                let nextButton = UIButton()
                sectionView.addSubview(nextButton)
                nextButton.translatesAutoresizingMaskIntoConstraints = false
                nextButton.topAnchor.constraint(equalTo: sectionView.topAnchor).isActive = true
                nextButton.bottomAnchor.constraint(equalTo: sectionView.bottomAnchor).isActive = true
                nextButton.trailingAnchor.constraint(equalTo: sectionView.trailingAnchor, constant: -15).isActive = true
                nextButton.setTitleColor(.white, for: .normal)
                nextButton.setImage(UIImage(systemName: "arrow.right"), for: .normal)
                nextButton.tintColor = .white
                nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
            }

            return sectionView
        } else {
            guard let viewModel = okvedTableViewViewModel else { return UIView() }
            let sectionView = UIView()
            sectionView.layer.borderWidth = 0.3
            sectionView.layer.borderColor = UIColor.black.cgColor
            sectionView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
            
            let arrowImage = UIImageView()
            sectionView.addSubview(arrowImage)
            arrowImage.translatesAutoresizingMaskIntoConstraints = false
            arrowImage.topAnchor.constraint(equalTo: sectionView.topAnchor).isActive = true
            arrowImage.bottomAnchor.constraint(equalTo: sectionView.bottomAnchor).isActive = true
            arrowImage.trailingAnchor.constraint(equalTo: sectionView.trailingAnchor, constant: -10).isActive = true
            arrowImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
            arrowImage.image = UIImage(systemName: "chevron.down")
            arrowImage.tintColor = .red
            arrowImage.contentMode = .scaleAspectFit
            
            let titleLabel = UILabel()
            sectionView.addSubview(titleLabel)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.topAnchor.constraint(equalTo: sectionView.topAnchor, constant: 7).isActive = true
            titleLabel.leadingAnchor.constraint(equalTo: sectionView.leadingAnchor, constant: 10).isActive = true
            titleLabel.trailingAnchor.constraint(equalTo: arrowImage.leadingAnchor, constant: -10).isActive = true
            titleLabel.bottomAnchor.constraint(equalTo: sectionView.bottomAnchor, constant: -7).isActive = true
            titleLabel.font = UIFont.systemFont(ofSize: 15.5)
            
            titleLabel.text = viewModel.titleForHeaderInSection(section: section)
            titleLabel.numberOfLines = 0
            
            let expandButton = UIButton()
            sectionView.addSubview(expandButton)
            expandButton.translatesAutoresizingMaskIntoConstraints = false
            expandButton.topAnchor.constraint(equalTo: sectionView.topAnchor).isActive = true
            expandButton.leadingAnchor.constraint(equalTo: sectionView.leadingAnchor).isActive = true
            expandButton.trailingAnchor.constraint(equalTo: sectionView.trailingAnchor).isActive = true
            expandButton.bottomAnchor.constraint(equalTo: sectionView.bottomAnchor).isActive = true
            expandButton.addTarget(self, action: #selector(expandButtonPressed), for: .touchUpInside)
            expandButton.tag = section
            
            if section == openSection {
                sectionView.backgroundColor = .red
                titleLabel.textColor = .white
            } else {
                sectionView.backgroundColor = .white
                titleLabel.textColor = .black
            }
            return sectionView
        }
    }
    
    @objc func expandButtonPressed(sender: UIButton) {
        openSection = openSection == sender.tag ? nil : sender.tag
        guard let viewModel = okvedTableViewViewModel else { return }
        viewModel.getCodes(section: sender.tag)
    }
    
    func setupOkvedTableView(view: UIView) {
        view.addSubview(okvedMainView)
        okvedMainView.translatesAutoresizingMaskIntoConstraints = false
        okvedMainView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        okvedMainView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        okvedMainView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        okvedMainView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        okvedMainView.addSubview(searchBar)
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.topAnchor.constraint(equalTo: okvedMainView.safeAreaLayoutGuide.topAnchor).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: okvedMainView.leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: okvedMainView.trailingAnchor).isActive = true
        
        okvedMainView.addSubview(okvedTableView)
        okvedTableView.translatesAutoresizingMaskIntoConstraints = false
        okvedTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        okvedTableView.leadingAnchor.constraint(equalTo: okvedMainView.leadingAnchor).isActive = true
        okvedTableView.trailingAnchor.constraint(equalTo: okvedMainView.trailingAnchor).isActive = true
        okvedTableView.bottomAnchor.constraint(equalTo: okvedMainView.bottomAnchor).isActive = true
        okvedTableView.register(OkvedTableViewCell.self, forCellReuseIdentifier: "okvedTableViewCell")
        okvedTableView.delegate = self
        okvedTableView.dataSource = self
        okvedMainView.addSubview(okvedDoneButton)
        okvedDoneButton.translatesAutoresizingMaskIntoConstraints = false
        okvedDoneButton.bottomAnchor.constraint(equalTo: okvedMainView.safeAreaLayoutGuide.bottomAnchor, constant: -40).isActive = true
        okvedDoneButton.centerXAnchor.constraint(equalTo: okvedMainView.centerXAnchor).isActive = true
        okvedDoneButton.widthAnchor.constraint(equalToConstant: 220).isActive = true
        okvedDoneButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        okvedDoneButton.layer.cornerRadius = 7
        okvedDoneButton.backgroundColor = .red
        okvedDoneButton.setTitle("Готово", for: .normal)
        okvedDoneButton.addTarget(self, action: #selector(doneButtonPressed), for: .touchUpInside)
    }
    
    @objc func doneButtonPressed() {
        okvedMainView.removeFromSuperview()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let viewModel = makeIPViewModel else { return 60 }
        if viewModel.currentSection == 2 && indexPath.row == 0 && viewModel.chosenOkveds.count == 0 {
            return 85
        } else {
            return 60
        }
    }
    
    @objc func nextButtonPressed() {
        guard let viewModel = makeIPViewModel else { return }
        tableView.reloadData()
        viewModel.nextButtonPressed()
        tableView.reloadData()
    }
    
    @objc func prevButtonPressed() {
        guard let viewModel = makeIPViewModel else { return }
        tableView.reloadData()
        viewModel.prevButtonPressed()
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tableView {
            guard let viewModel = makeIPViewModel else { return }
            viewModel.didSelectRow(indexPath: indexPath)
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            guard let makeIPviewModel = makeIPViewModel, let okvedViewModel = okvedTableViewViewModel else { return }
            okvedViewModel.didSelectRow(indexPath: indexPath, ipViewModel: makeIPviewModel, tableView: tableView)
        }
        
    }
}

extension MakeIPViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == self.tableView {
            return 1
        } else {
            guard let viewModel = okvedTableViewViewModel else { return 0}
            return viewModel.numberOfSections()
        }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            guard let viewModel = makeIPViewModel else { return 0}
            return viewModel.numberOfRowsInSection(section: section)
        } else {
            guard let viewModel = okvedTableViewViewModel else { return 0}
            return viewModel.numberOfRowsInSection(section: section)
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? MakeIPTableViewCell
            guard let tableViewCell = cell, let viewModel = makeIPViewModel else { return UITableViewCell() }
            let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath, viewController: self)
            tableViewCell.viewModel = cellViewModel
            return tableViewCell
        } else {
            let cell = okvedTableView.dequeueReusableCell(withIdentifier: "okvedTableViewCell", for: indexPath) as? OkvedTableViewCell
            
            guard let tableViewCell = cell else { return UITableViewCell() }
            let cellViewModel = okvedTableViewViewModel!.cellViewModel(forIndexPath: indexPath)
            tableViewCell.viewModel = cellViewModel
            
            return tableViewCell
        }
    }
}

extension MakeIPViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(1)
        guard let viewModel = makeIPViewModel else { return }
        if let text = textField.text, text != "" {
            viewModel.setTextFieldInfo(text: text, index: textField.tag)
//            tableView.reloadData()
        } else {
            animations.animateTextLabels(textField: textField, y: 0, tableView: tableView)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print(2)
        animations.animateTextLabels(textField: textField, y: -20, tableView: tableView)
        guard let viewModel = makeIPViewModel else { return }
        mask.setupMask(textField: textField, tag: textField.tag, section: viewModel.currentSection)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let viewModel = makeIPViewModel else { return false }
        return mask.validateTextField(textField: textField, letter: string, section: viewModel.currentSection)
    }
}

extension MakeIPViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let viewModel = makeIPViewModel else { return nil }
        return viewModel.titleForRowInPickerView(row: row, pickerView: pickerView)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let viewModel = makeIPViewModel else { return }
        if viewModel.currentSection == 0 {
            viewModel.setTextFieldInfo(text: Constants.genders[row], index: 3)
        } else if viewModel.currentSection == 3 {
            if pickerView.tag == 0 {
                viewModel.setTextFieldInfo(text: Constants.taxes[row], index: 0)
            } else if pickerView.tag == 1 {
                viewModel.setTextFieldInfo(text: Constants.taxesRate[row], index: 1)
            }
            
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
    func didDismissDatePicker(text: String, index: Int) {
        guard let viewModel = makeIPViewModel else { return }
        viewModel.setTextFieldInfo(text: text, index: index)
        tableView.reloadData()
    }
}

extension MakeIPViewController: PrevNextButtonsDelegate {
    func prevNextButtonPressed(sender: UIButton) {
        guard let viewModel = makeIPViewModel else { return}
        tableView.reloadData()
        viewModel.nextButtonPressed()
        tableView.reloadData()
    }
}

extension MakeIPViewController: OkvedDelegate {
    func setupViewModel() {
        okvedTableViewViewModel = OkvedTableViewViewModel(tableView: okvedTableView, viewModel: makeIPViewModel)
    }
    
    func addOkvedsButtonPressed() {
        setupOkvedTableView(view: view)
    }
}


extension MakeIPViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let viewModel = okvedTableViewViewModel else { return }
        viewModel.searchBarTextDidChange(text: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            guard let viewModel = okvedTableViewViewModel else { return }
            viewModel.searchBarTextDidChange(text: text)
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.superview?.addSubview(newView)
        newView.translatesAutoresizingMaskIntoConstraints = false
        newView.topAnchor.constraint(equalTo: searchBar.superview!.topAnchor).isActive = true
        newView.leadingAnchor.constraint(equalTo: searchBar.superview!.leadingAnchor).isActive = true
        newView.trailingAnchor.constraint(equalTo: searchBar.superview!.trailingAnchor).isActive = true
        newView.bottomAnchor.constraint(equalTo: searchBar.superview!.bottomAnchor).isActive = true
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
