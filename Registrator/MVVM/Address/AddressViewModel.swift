//
//  AddressViewVeiwModel.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 07.10.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

class AddressVeiwModel {

    var dataArr: [Address] = []
    var step = AddressStep.search
    var chosenAddress: Address?
    let id: String
    var router: AddressRouter!
    let docType: DocType
    let disposeBag = DisposeBag()
    
    init(id: String, docType: DocType) {
        self.id = id
        self.docType = docType
    }
    
    func subscribeToSearchBar(searchBar: UISearchBar, completion: @escaping (() -> Void)) {
        searchBar.rx.value.subscribe(onNext: { [weak self] (text) in
            guard let text = text else { return }
            Request.addressNote.getNote(text: text) { [weak self] (data) in
                self?.dataArr = data
                AddressStep.searchCount = data.count
                completion()
            }
        }).disposed(by: disposeBag)
    }
    
    func changeStep() {
        step.changeStep()
    }
    
    var numberOfRows: Int {
        return step.fields.count
    }
    
    func didSelectRowAt(row: Int, completion: @escaping(() -> Void)) {
        guard let address = step == .search ? dataArr[row] : chosenAddress else { return }
        step.fields[row].didSelectRow(address: address, id: id, docType: docType) { [weak self] (address) in
            if let newAdr = address {
                self?.chosenAddress = newAdr
                self?.changeStep()
                completion()
            } else {
                self?.router.dismissModule()
            }
        }
    }
    
    func cellViewModel(for indexPath: IndexPath) -> AddressCellViewModel? {
        let item = step.fields[indexPath.row]
        var text = ""
        if step == .search {
            text = dataArr[indexPath.row].strValue
        } else {
            if let address = chosenAddress {
                text = address.cellText(type: item)
            }
        }
        let isAreaNeed = chosenAddress?.isAreaNeed == "Yes" ? true : false
        return AddressCellViewModel(title: item.rawValue, text: text, step: step, note: item.note, isAreaNeed: isAreaNeed, type: item)
    }
}
