//
//  OkvedTableViewViewModel.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 11.08.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import UIKit
import RealmSwift

class OkvedTableViewViewModel {
    let okvedManager = OKVEDManager()
    var codes: [OKVED] = []
    var openSection: Int?
    let tableView: UITableView
    let realm = try! Realm()
    var selectedCodes: Results<Code>?
    var selectedSections: Results<Class>?
    var sectionsArray: [[String]] = []
    var selectedCodesArray: [Results<Code>] = []
    var makeIPViewModel: MakeIPViewModel?
    var chosenCodes: [OKVED] = []
    
    init(tableView: UITableView, viewModel: MakeIPViewModel?) {
        self.tableView = tableView
        self.makeIPViewModel = viewModel
        guard let ipViewModel = makeIPViewModel else { return }
        chosenCodes = ipViewModel.chosenOkveds
        
    }
    
    func titleForHeaderInSection(section: Int) -> String {
        if selectedSections != nil {
            return "\(sectionsArray[section][0]). \(sectionsArray[section][1])"
        } else {
            return "\(okvedManager.okvedClasses[section][0]). \(okvedManager.okvedClasses[section][1])"
        }
    }
    
    func numberOfSections() -> Int {
        if selectedSections != nil {
            return sectionsArray.count
        } else {
            return okvedManager.okvedClasses.count
        }
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        if selectedSections != nil {
            return selectedCodesArray[section].count
        } else {
            if let openSec = openSection {
                if section == openSec {
                    return realm.object(ofType: Class.self, forPrimaryKey: okvedManager.okvedClasses[section][0])?.codes.count ?? 0
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
            return OkvedCellViewModel(kod: kod, descr: descr, isChosen: checkIfCodeIsSelected(code: kod))
        } else {
            if let section = openSection {
                let kod = (realm.object(ofType: Class.self, forPrimaryKey: okvedManager.okvedClasses[section][0])?.codes.sorted(byKeyPath: "code")[indexPath.row].code)!
                let descr = (realm.object(ofType: Class.self, forPrimaryKey: okvedManager.okvedClasses[section][0])?.codes.sorted(byKeyPath: "code")[indexPath.row].descr)!
                return OkvedCellViewModel(kod: kod, descr: descr, isChosen: checkIfCodeIsSelected(code: kod))
            } else {
                return nil
            }
        }
    }
    
    func didSelectRow(indexPath: IndexPath, ipViewModel: MakeIPViewModel, tableView: UITableView) {
        if selectedSections != nil {
            let kod = selectedCodesArray[indexPath.section][indexPath.row].code!
            if checkIfCodeIsSelected(code: kod) {
                chosenCodes.removeAll (where: { $0.kod == kod })
            } else {
                let descr = selectedCodesArray[indexPath.section][indexPath.row].descr!
                let newKod = OKVED(kod: kod, descr: descr)
                chosenCodes.append(newKod)
            }
            ipViewModel.setOkveds(okveds: chosenCodes)
            tableView.reloadData()
        } else {
            let kod = (realm.object(ofType: Class.self, forPrimaryKey: okvedManager.okvedClasses[indexPath.section][0])?.codes.sorted(byKeyPath: "code")[indexPath.row].code)!
            if checkIfCodeIsSelected(code: kod) {                
                chosenCodes.removeAll (where: { $0.kod == kod })
            } else {
                let descr = (realm.object(ofType: Class.self, forPrimaryKey: okvedManager.okvedClasses[indexPath.section][0])?.codes.sorted(byKeyPath: "code")[indexPath.row].descr)!
                let newKod = OKVED(kod: kod, descr: descr)
                chosenCodes.append(newKod)
            }
            ipViewModel.setOkveds(okveds: chosenCodes)
            tableView.reloadData()
        }
    }
    
    func getCodes(section: Int) {
        if openSection == section {
            openSection = nil
            self.tableView.reloadData()
        } else {
            openSection = section
            self.tableView.reloadData()
            self.tableView.scrollToRow(at: [section, 0], at: .top, animated: true)
        }
    }
    
    func searchBarSearchButtonClicked(text: String) {
        selectedCodes = realm.objects(Code.self).filter("descr CONTAINS[cd] %@", text)
        selectedSections = realm.objects(Class.self).filter("SUBQUERY(codes, $code, $code.descr CONTAINS[cd] %@).@count > 0", text)
        tableView.reloadData()
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
        
        tableView.reloadData()
    }
}
