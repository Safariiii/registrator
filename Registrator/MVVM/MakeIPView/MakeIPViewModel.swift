//
//  MakeIPViewModel.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 23.07.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//
import Foundation
import Firebase

class MakeIPViewModel {
    
    var router: MakeIPRouter!
    let id: String
    let isNew: Bool
    var newFile: File?
    var reloadHandler: (() -> Void)?
    var addOkvedView: (() -> Void)?
    let firebaseManager = FirebaseManager()
    var steps = Step(rawValue: 0)
    /*var steps = Step.step1
    var steps: Step = .step1
 */
    
    init(id: String, isNew: Bool) {
        self.id = id
        self.isNew = isNew
        if !isNew {
            createTextFields()
        } else {
            newFile = File()
            steps?.createNewDoc(id: id)
        }
    }
    
    deinit {
        print("deinit MakeIPViewModel")
    }
    
    func okvedRoute() {
        guard let file = newFile else { return }
        router.okvedRoute(okveds: file.okveds, id: id)
    }
    
    func createTextFields() {
        firebaseManager.createTextFields(id: id) { [weak self] (file, okveds) in
            guard let self = self else {
                return
            }
            self.newFile = file
            Step.okveds = self.newFile!.okveds
            self.reloadHandler?()
        }
    }
    
    func nextButtonPressed() {
        steps?.nextSection()
    }
    
    func prevButtonPressed() {
        steps?.prevSection()
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        guard let step = steps else { return 0 }
        return step.fields.count
    }
    
    func titleForHeaderInSection() -> String {
        guard let step = steps else { return "" }
        return step.title
    }
    
    func didSelectRow(index: Int) {
        guard let step = steps else {
            return
        }
        let field = step.fields[index]
        
        if field == .giveMethod {
            field.save(text: newFile!.giveMethods[index], id: id, okveds: nil)
            reloadHandler?()
        } else if field == .none {
            nextButtonPressed()
            reloadHandler?()
        } else if field == .addOkved {
            addOkvedView?()
        }
    }
    
    func cellViewModel(indexPath: IndexPath) -> CellViewModel? {
        guard var newFile = newFile, let step = steps else { return nil }
        let item = step.fields[indexPath.row]
        let text = newFile.cellText(title: item.rawValue, row: indexPath.row)
        
        switch item.group {
        case .text:
            return TextCellViewModel(title: item.rawValue, text: text, id: id, validateType: item.validateType, type: item)
        case .picker:
            return PickerCellViewModel(title: item.rawValue, text: text, id: id, fields: item.selectFields, type: item)
        case .datePicker:
            return CellViewModel(title: item.rawValue, text: text, id: id, type: item)
        case .giveMethod:
            return GiveMethodCellViewModel(title: text, id: id, giveMethod: newFile.giveMethod, type: item)
        case .okveds:
            return OkvedTypeCellViewModel(text: text, id: id, type: item)
        case .none:
            return NextButtonViewModel()
        case .addOkved:
            return AddOkvedViewModel(okveds: newFile.okveds)
        }
    }
}
