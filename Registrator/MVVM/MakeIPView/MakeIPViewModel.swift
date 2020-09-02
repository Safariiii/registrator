//
//  MakeIPViewModel.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 23.07.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import Foundation
//import UIKit
import Firebase

class MakeIPViewModel {
    
    let id: String
    private let ipManager: DocumentManager
    let isNew: Bool
    var textFieldInfo: [[String]]
    private let db: Firestore
    private var tableView: UITableView
    var currentSection = 0
    var okvedDelegate: OkvedDelegate?
    private var viewController: UIViewController
    
    var reloadHandler: (() -> Void)?
    // вынести во вьюмодель
    
    init(id: String, isNew: Bool, tableView: UITableView, viewController: UIViewController) {
        self.id = id
        self.isNew = isNew
        //self.tableView = tableView
        self.ipManager = DocumentManager(id: id)
        //self.viewController = viewController
        db = Firestore.firestore()
        self.okvedDelegate = self.viewController as? OkvedDelegate
        
        if !isNew {
            self.textFieldInfo = [["", "", "", "", "", "", "", ""], ["", "", "", "", "", "", "", "", ""], [], ["", ""]]
            createTextFields(id: id)
        } else {
            self.textFieldInfo = [["", "", "", "", "", "", "", ""], ["", "", "", "", "", "", "", "", ""], [], ["", ""]]
            self.okvedDelegate?.setupViewModel()
        }
    }
    
    func nextButtonPressed() {
        if currentSection + 1 < headersLabelsArray.count {
            currentSection += 1
        }
    }
    
    func prevButtonPressed() {
        if currentSection != 0 {
            currentSection -= 1
        }
    }
    
    var loadedOkveds: [String : String] = [:]
    var chosenOkveds: [OKVED] = []
    
    func setOkveds(okveds: [OKVED]) {
        loadedOkveds = [:]
        var kodes: [String] = []
        for i in 0..<okveds.count {
            let kod = okveds[i].kod
            let descr = okveds[i].descr
            let kodString = "\(kod). \(descr)"
            kodes.append(kodString)
            loadedOkveds[kod] = descr
        }
        stepsLabelsArray[2] = kodes
        saveDocument()
        //tableView.reloadData()
        reloadHandler?()
    }
    
    private func createTextFields(id: String) {
        db.collection("documents").document("CurrentUser").collection("IP").document(id).getDocument { (querySnapshot, error) in
            
            guard let snapshot = querySnapshot else {
                print("Error retreiving snapshot: \(error!)")
                return
            }
            if let data = snapshot.data() {
                self.textFieldInfo = [[], [], [], []]
                self.textFieldInfo[0].append(data["lastName"] as! String)
                self.textFieldInfo[0].append(data["firstName"] as! String)
                self.textFieldInfo[0].append(data["middleName"] as! String)
                self.textFieldInfo[0].append(data["sex"] as! String)
                self.textFieldInfo[0].append(data["citizenship"] as! String)
                self.textFieldInfo[0].append(data["dateOfBirth"] as! String)
                self.textFieldInfo[0].append(data["email"] as! String)
                self.textFieldInfo[0].append(data["phoneNumber"] as! String)
                self.textFieldInfo[1].append(data["passportSeries"] as! String)
                self.textFieldInfo[1].append(data["passportNumber"] as! String)
                self.textFieldInfo[1].append(data["passportDate"] as! String)
                self.textFieldInfo[1].append(data["passportGiver"] as! String)
                self.textFieldInfo[1].append(data["passportCode"] as! String)
                self.textFieldInfo[1].append(data["placeOfBirth"] as! String)
                self.textFieldInfo[1].append(data["address"] as! String)
                self.textFieldInfo[1].append(data["inn"] as! String)
                self.textFieldInfo[1].append(data["snils"] as! String)
                self.textFieldInfo[3].append(data["taxesSystem"] as! String)
                self.textFieldInfo[3].append(data["taxesRate"] as! String)
                self.giveMethod = data["giveMethod"] as! String
                self.loadedOkveds = data["okveds"] as! [String : String]
                var okvedsToDisplay: [String] = []
                for item in self.loadedOkveds {
                    let okved = OKVED(kod: item.key, descr: item.value)
                    self.chosenOkveds.append(okved)
                    okvedsToDisplay.append("\(item.key). \(item.value)")
                }
                self.stepsLabelsArray[2] = okvedsToDisplay
                //self.tableView.reloadData()
                self.reloadHandler?()
                self.okvedDelegate?.setupViewModel()
            }
        }
    }
    
    func titleForRowInPickerView(row: Int, pickerView: UIPickerView) -> String {
        if currentSection == 0 {
            return Constants.genders[row]
        } else if currentSection == 3 {
            if pickerView.tag == 0 {
                return Constants.taxes[row]
            } else if pickerView.tag == 1 {
                return Constants.taxesRate[row]
            }
        }
        return "Ошибка"
    }

    
    private var stepsLabelsArray: [[String]] = [["Фамилия: ", "Имя: ", "Отчество: ", "Пол: ", "Гражданство: ", "Дата рождения: ", "E-mail: ", "Номер телефона: "], ["Серия паспорта: ", "Номер паспорта: ", "Дата выдачи: ", "Кем выдан: ", "Код подразделения: ", "Место рождения: ", "Адрес регистрации: ", "ИНН: ", "СНИЛС: "], ["В данный момент нет добавленных кодов ОКВЭД"], ["Система нологообложения: ", "Ставка налогообложения: "], ["Лично", "По доверенности"]]
    
    private let headersLabelsArray = ["Шаг 1: Личная информация", "Шаг 2: Паспортные данные", "Шаг 3: ОКВЭД", "Шаг 4: Налогообложение", "Шаг 5: Способ подачи документов"]
    
    func numberOfSections() -> Int {
        return headersLabelsArray.count
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        if currentSection == 2 {
            return stepsLabelsArray[currentSection].count + 2
        } else {
            return stepsLabelsArray[currentSection].count + 1
        }
    }
    
    private var giveMethod = ""
    
    func didSelectRow(indexPath: IndexPath) {
        if currentSection == 4 {
            if indexPath.row == 0 {
                giveMethod = "Лично"
            } else if indexPath.row == 1 {
                giveMethod = "По доверенности"
            }
            saveDocument()
            //self.tableView.reloadData()
            reloadHandler?()
        }
    }
    
    func titleForHeaderInSection(section: Int) -> String {
        return headersLabelsArray[currentSection]
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath, viewController: UIViewController) -> MakIPCellViewModel? {
        
        var cellTitle = ""
        var cellText = ""
        if indexPath.row < stepsLabelsArray[currentSection].count {
            cellTitle = stepsLabelsArray[currentSection][indexPath.row]
            if currentSection < 2 {
                cellText = textFieldInfo[currentSection][indexPath.row]
            } else if currentSection == 3 {
                cellText = textFieldInfo[currentSection][indexPath.row]
            }
        } else if currentSection == 2 && indexPath.row == stepsLabelsArray[currentSection].count {
            cellTitle = "Кнопка добавить ОКВЭД"
        }
        return MakIPCellViewModel(cellTitle: cellTitle, cellText: cellText, cellIndexPath: indexPath, viewController: viewController, currentSection: currentSection, giveMethod: giveMethod)
    }
    
    func setTextFieldInfo(text: String, index: Int) {
        textFieldInfo[currentSection][index] = text
        saveDocument()
    }
    
    private func saveDocument() {
        if stepsLabelsArray[2][0] != "В данный момент нет добавленных кодов ОКВЭД" {
            ipManager.saveDocument(textFields: textFieldInfo, id: id, okveds: loadedOkveds, giveMethod: giveMethod)
        } else {
            ipManager.saveDocument(textFields: textFieldInfo, id: id, okveds: [:], giveMethod: giveMethod)
        }
    }
}
