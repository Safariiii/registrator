//
//  MakeIPViewModel.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 23.07.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFunctions
import RxSwift

class MakeIPViewModel {
    
    var router: MakeIPRouter!
    let id: String
    let isNew: Bool
    var newFile: File?
    var reloadHandler: (() -> Void)?
    var showStatusAlert: ((String, String) -> Void)?
    var addSatusView: ((UIView) -> Void)?
    var steps: Step
    var docType: DocType
    let disposeBag = DisposeBag()
    
    
    init(id: String, isNew: Bool, type: DocType) {
        self.id = id
        self.isNew = isNew
        self.docType = type
        self.steps = type.firstStep
        if !isNew {
            createTextFields()
        } else {
            docType.createNewDoc(id: id) { [weak self] in
                self?.createTextFields()
            }
        }
    }

    func createTextFields() {
        docType.createTextFields(id: id) { [weak self] (file) in
            guard let self = self else {
                return
            }
            self.newFile = file
            if let okveds = self.newFile?.okveds {
                Step.okveds = okveds
            }
            self.reloadHandler?()
        }
    }
    
    func nextButtonPressed() {
        steps.nextSection()
    }
    
    func prevButtonPressed() {
        steps.prevSection()
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        return steps.fields.count
    }
    
    func titleForHeaderInSection() -> String {
        return steps.title
    }
    
    func didSelectRow(index: Int) {
        steps.fields[index].didSelectRow(newFile: newFile, docType: docType, id: id, index: index, reloadHandler: reloadHandler, nextButtonPressed: nextButtonPressed, addSatusView: addSatusView, showStatusAlert: showStatusAlert, router: router)
    }
    
    func cellViewModel(indexPath: IndexPath) -> CellViewModel? {
        guard var newFile = newFile else { return nil }
        let item = steps.fields[indexPath.row]
        let text = newFile.cellText(title: item.rawValue, row: indexPath.row)
        
        return item.group.cellViewModel(indexPath: indexPath, item: item, text: text, newFile: newFile, id: id, docType: docType)
    }
}
