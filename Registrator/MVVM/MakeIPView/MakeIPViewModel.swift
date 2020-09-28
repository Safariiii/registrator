//
//  MakeIPViewModel.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 23.07.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//
import Foundation

class MakeIPViewModel {
    
    let id: String
    let isNew: Bool
    var currentSection = 0
    var newFile: File?
    var reloadHandler: (() -> Void)?
    let firebaseManager = FirebaseManager()
    var stepsLabelsArray: [[String]] = [["Фамилия: ", "Имя: ", "Отчество: ", "Пол: ", "Гражданство: ", "Дата рождения: ", "E-mail: ", "Номер телефона: "], ["Серия паспорта: ", "Номер паспорта: ", "Дата выдачи: ", "Кем выдан: ", "Код подразделения: ", "Место рождения: ", "Адрес регистрации: ", "ИНН: ", "СНИЛС: "], ["В данный момент нет добавленных кодов ОКВЭД"], ["Система нологообложения: ", "Ставка налогообложения: "], ["Лично", "По доверенности"]]
     
    private let headersLabelsArray = ["Шаг 1: Личная информация", "Шаг 2: Паспортные данные", "Шаг 3: ОКВЭД", "Шаг 4: Налогообложение", "Шаг 5: Способ подачи документов"]
    
    init(id: String, isNew: Bool) {
        self.id = id
        self.isNew = isNew
        if !isNew {
            createTextFields()
        } else {
            newFile = File()
        }
    }
    
    func createTextFields() {
        firebaseManager.createTextFields(id: id) { (file, okveds) in
            if okveds != [] {
                self.stepsLabelsArray[2] = okveds
            }
            self.newFile = file
            self.reloadHandler?()
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
    
    func setOkveds(okveds: [OKVED]) {
        newFile?.okveds = []
        var kodes: [String] = []

        for i in 0..<okveds.count {
            let kod = okveds[i].kod
            let descr = okveds[i].descr
            let kodString = "\(kod). \(descr)"
            kodes.append(kodString)
            newFile?.okveds.append(okveds[i])
        }
        stepsLabelsArray[2] = kodes
        saveDocument()
        reloadHandler?()
    }
    
    func titleForRowInPickerView(row: Int, type: PickerViewType) -> String {
        switch type {
        case .genders:
            return Constants.genders[row]
        case .taxesSystem:
            return Constants.taxes[row]
        case .taxesRate:
            return Constants.taxesRate[row]
        default:
            return "Ошибка"
        }
    }

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
    
    func didSelectRow(index: Int) {
        if currentSection == 4 {
            if index == 0 {
                newFile?.giveMethod = "Лично"
            } else if index == 1 {
                newFile?.giveMethod = "По доверенности"
            }
            saveDocument()
            reloadHandler?()
        }
        if index == stepsLabelsArray[currentSection].count {
            nextButtonPressed()
            reloadHandler?()
        } else if index == stepsLabelsArray[currentSection].count + 1 {
            nextButtonPressed()
            reloadHandler?()
        }
        
    }
    
    func titleForHeaderInSection() -> String {
        return headersLabelsArray[currentSection]
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> MakIPCellViewModel? {
        
        var cellTitle = ""
        var cellText = ""
        let data = stepsLabelsArray[currentSection]
        if indexPath.row < data.count {
            cellTitle = data[indexPath.row]
            if currentSection != 2 && currentSection != 4 {
                if var newFile = newFile {
                    cellText = newFile.cellText(title: cellTitle)
                }
            }
        } else if currentSection == 2 && indexPath.row == data.count {
            cellTitle = "Кнопка добавить ОКВЭД"
        }
        return MakIPCellViewModel(cellTitle: cellTitle, cellText: cellText, tag: indexPath.row, currentSection: currentSection, giveMethod: newFile?.giveMethod ?? "")
    }
    
    func setTextFieldInfo(text: String, type: TextFieldType) {
        newFile?.setTextField(text: text, type: type)
        saveDocument()
    }
    
    private func saveDocument() {
        firebaseManager.saveDocumentToFirestore(file: newFile!, id: id, okveds: newFile?.okveds)
    }
}
