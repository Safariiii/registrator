//
//  OkvedTableViewViewModel.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 11.08.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import Foundation
import RealmSwift

class OkvedTableViewViewModel {
    var openSection: Int?
    let realm = try! Realm()
    var id: String
    var selectedCodes: Results<Code>?
    var selectedSections: Results<Class>?
    var sectionsArray: [[String]] = []
    var selectedCodesArray: [Results<Code>] = []
    var chosenCodes: [OKVED] = []
    var reloadHandler: (() -> Void)?
    var alertMessage: (() -> Void)?
    var scrollToRow: ((_ indexPath: IndexPath) -> Void)?
    var router: OkvedRouter!
    var mainOkved: String
    var collectionName: String
    var okvedCounter: Int {
        return chosenCodes.count
    }
    var isAlowed: Bool {
        if chosenCodes.count > 56 {
            return false
        }
        return true
    }
    
    init(okveds: [OKVED], id: String, mainOkved: String, collectionName: String) {
        chosenCodes = okveds
        self.collectionName = collectionName
        self.id = id
        self.mainOkved = mainOkved
    }
    
    func titleForHeaderInSection(section: Int) -> String {
        if selectedSections != nil {
            return "\(sectionsArray[section][0]). \(sectionsArray[section][1])"
        } else {
            return "\(Constants.okvedClasses[section][0]). \(Constants.okvedClasses[section][1])"
        }
    }
    
    func numberOfSections() -> Int {
        if selectedSections != nil {
            return sectionsArray.count
        } else {
            return Constants.okvedClasses.count
        }
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        if selectedSections != nil {
            return selectedCodesArray[section].count
        } else {
            if let openSec = openSection {
                if section == openSec {
                    return realm.object(ofType: Class.self, forPrimaryKey: Constants.okvedClasses[section][0])?.codes.count ?? 0
                } else {
                    return 0
                }
            } else {
                return 0
            }
        }
    }
    
    private func checkIfCodeIsSelected(code: String) -> Bool {
        for item in chosenCodes {
            if item.kod == code {
                return true
            }
        }
        return false
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> OkvedCellViewModel? {
        if selectedSections != nil {
            let kod = selectedCodesArray[indexPath.section][indexPath.row].code!
            let descr = selectedCodesArray[indexPath.section][indexPath.row].descr!
            let text = "\(kod). \(descr)"
            return OkvedCellViewModel(text: text, isChosen: checkIfCodeIsSelected(code: kod))
        } else {
            if let section = openSection {
                let kod = (realm.object(ofType: Class.self, forPrimaryKey: Constants.okvedClasses[section][0])?.codes.sorted(byKeyPath: "code")[indexPath.row].code)!
                let descr = (realm.object(ofType: Class.self, forPrimaryKey: Constants.okvedClasses[section][0])?.codes.sorted(byKeyPath: "code")[indexPath.row].descr)!
                let text = "\(kod). \(descr)"
                return OkvedCellViewModel(text: text, isChosen: checkIfCodeIsSelected(code: kod))
            } else {
                return nil
            }
        }
    }
    
    func didSelectRow(indexPath: IndexPath) {
        if selectedSections != nil {
            let okvedField = TextFieldType.addOkved
            let kod = selectedCodesArray[indexPath.section][indexPath.row].code!
            if checkIfCodeIsSelected(code: kod) {
                chosenCodes.removeAll (where: { $0.kod == kod })
                okvedField.save(text: "", id: id, collectionName: collectionName, okveds: chosenCodes)
                reloadHandler?()
            } else {
                if isAlowed {
                    let descr = selectedCodesArray[indexPath.section][indexPath.row].descr!
                    let newKod = OKVED(kod: kod, descr: descr)
                    chosenCodes.append(newKod)
                    okvedField.save(text: "", id: id, collectionName: collectionName, okveds: chosenCodes)
                    if mainOkved == ". " {
                        TextFieldType.okveds.save(text: "", id: id, collectionName: collectionName, okveds: [newKod])
                        mainOkved = "aaa"
                    }
                    reloadHandler?()
                } else {
                    alertMessage?()
                }
            }
        } else {
            let okvedField = TextFieldType.addOkved
            let kod = (realm.object(ofType: Class.self, forPrimaryKey: Constants.okvedClasses[indexPath.section][0])?.codes.sorted(byKeyPath: "code")[indexPath.row].code)!
            if checkIfCodeIsSelected(code: kod) {
                chosenCodes.removeAll (where: { $0.kod == kod })
                okvedField.save(text: "", id: id, collectionName: collectionName, okveds: chosenCodes)
                reloadHandler?()
            } else {
                if isAlowed {
                    let descr = (realm.object(ofType: Class.self, forPrimaryKey: Constants.okvedClasses[indexPath.section][0])?.codes.sorted(byKeyPath: "code")[indexPath.row].descr)!
                    let newKod = OKVED(kod: kod, descr: descr)
                    chosenCodes.append(newKod)
                    okvedField.save(text: "", id: id, collectionName: collectionName, okveds: chosenCodes)
                    if mainOkved == ". " {
                        TextFieldType.okveds.save(text: "", id: id, collectionName: collectionName, okveds: [newKod])
                        mainOkved = "aaa"
                    }
                    reloadHandler?()
                } else {
                    alertMessage?()
                }
            }
        }
    }
    
    func getCodes(section: Int) {
        if openSection == section {
            openSection = nil
            reloadHandler?()
        } else {
            openSection = section
            reloadHandler?()
            scrollToRow?([section, 0])
        }
    }
    
    func searchBarSearchButtonClicked(text: String) {
        selectedCodes = realm.objects(Code.self).filter("descr CONTAINS[cd] %@", text)
        selectedSections = realm.objects(Class.self).filter("SUBQUERY(codes, $code, $code.descr CONTAINS[cd] %@).@count > 0", text)
        reloadHandler?()
    }
    
    func searchBarTextDidChange(text: String) {
        if text.count != 0 {
            selectedCodes = realm.objects(Code.self).filter("descr CONTAINS[cd] %@", text)
            selectedSections = realm.objects(Class.self).filter("SUBQUERY(codes, $code, $code.descr CONTAINS[cd] %@).@count > 0", text)
            sectionsArray = []
            selectedCodesArray = []
            for item in selectedSections! {
                let array = [item.code!, item.descr!]
                let codes = selectedCodes?.filter("parentClassCode == %@", item.code!)
                selectedCodesArray.append(codes!)
                sectionsArray.append(array)
            }
        } else {
            selectedCodes = nil
            selectedSections = nil
        }
        reloadHandler?()
    }
    
    func dismissVC() {
        router.dismissModule()
    }
}
