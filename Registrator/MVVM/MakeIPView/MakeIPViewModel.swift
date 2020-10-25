//
//  MakeIPViewModel.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 23.07.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

fileprivate let okTitle = "Успешно"
fileprivate let okMessage = "Документы успешно сформированы и отправлены на адрес электронной почты, которая была указана в форме. Дальнейшие шаги по подаче документов содержатся в высланном Вам письме. Спасибо, что воспользовались нашим сервисом!"
fileprivate let errorTitle = "Ошибка"
fileprivate let errorMessage = "К сожалению нам не удалось отправить письмо на адрес электронной почты, указанной Вами при заполнении формы. Попробуйте указать другой адрес и заново повторите попытку."

import Foundation
import Firebase
import FirebaseFunctions

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
        let field = steps.fields[index]
        
        if field == .giveMethod {
            field.save(text: newFile!.giveMethods[index], id: id, collectionName: docType.collectionName, okveds: nil)
            reloadHandler?()
        } else if field == .none {
            nextButtonPressed()
            reloadHandler?()
        } else if field == .addOkved {
            guard let okveds = newFile?.okveds, let mo = newFile?.mainOkved else { return }
            let mainOkved = "\(mo[0].kod). \(mo[0].descr)"
            router.okvedRoute(okveds: okveds, id: id, mainOkved: mainOkved, collectionName: docType.collectionName)
        } else if field == .address {
            guard let address = newFile?.address else { return }
            router.addressRouter(id: id, address: address, docType: docType)
        } else if field == .okveds {
            guard let okveds = newFile?.okveds else { return }
            field.save(text: "", id: id, collectionName: docType.collectionName, okveds: [okveds[index]])
        } else if field == .buy {
            guard let file = newFile else { return }
            if file.errors.count > 0 {
                self.showStatusAlert?(errorTitle, file.errorMessage)
            } else {
                let statusView = StatusView()
                docType.sendDocument(id: id, waiting: {
                    self.addSatusView?(statusView)
                }) { [weak self] (status) in
                    statusView.removeFromSuperview()
                    if status == "ok" {
                        self?.showStatusAlert?(okTitle, okMessage)
                    } else if status == "error" {
                        self?.showStatusAlert?(errorTitle, errorMessage)
                    }
                }
            }
        }
    }
    
    func cellViewModel(indexPath: IndexPath) -> CellViewModel? {
        guard var newFile = newFile else { return nil }
        let item = steps.fields[indexPath.row]
        let text = newFile.cellText(title: item.rawValue, row: indexPath.row)
        
        switch item.group {
        case .text:
            return TextCellViewModel(title: item.rawValue, text: text, id: id, validateType: item.validateType, type: item, docType: docType)
        case .picker:
            return PickerCellViewModel(title: item.rawValue, text: text, id: id, taxSystem: item.taxesSystem(title: newFile.taxesSystem), fields: item.selectFields, type: item, docType: docType)
        case .datePicker:
            return CellViewModel(title: item.rawValue, text: text, id: id, type: item, docType: docType)
        case .giveMethod:
            return GiveMethodCellViewModel(title: text, id: id, giveMethod: newFile.giveMethod, type: item, docType: docType)
        case .okveds:
            guard let mo = newFile.mainOkved else { return CellViewModel(title: "", text: "", id: "", type: .none, docType: .makeIP) }
            let mainOkved = "\(mo[0].kod). \(mo[0].descr)"
            return OkvedTypeCellViewModel(text: text, id: id, type: item, mainOkved: mainOkved, docType: docType)
        case .none:
            return NextButtonViewModel(type: item, docType: docType)
        case .addOkved:
            guard let okveds = newFile.okveds else { return CellViewModel(title: "", text: "", id: "", type: .none, docType: .makeIP) }
            return AddOkvedViewModel(okveds: okveds, docType: docType)
        }
    }
}
