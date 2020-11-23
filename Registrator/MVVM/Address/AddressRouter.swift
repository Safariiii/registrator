//
//  AddressRouter.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 09.10.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import UIKit

class AddressRouter {
    weak var nc: UINavigationController?
    
    static var configurator: AddressConfigurator?
    
    static func showModule(nc: UINavigationController, documentId: String? = nil, address: String, docType: DocType) {
        configurator = AddressConfigurator(documentId: documentId, address: address, docType: docType)
        configurator?.router?.nc = nc
        if let vc = configurator?.view {
            nc.present(vc, animated: true, completion: nil)
        }
    }
    
    func dismissModule() {
        if let vc = AddressRouter.configurator?.view {
            vc.dismiss(animated: true, completion: nil)
        }
    }

}

class AddressConfigurator {
    var viewModel: AddressVeiwModel?
    var router: AddressRouter?
    var view: AddressView?
    
    init(documentId: String?, address: String, docType: DocType) {
        
        if let documentId = documentId {
            viewModel = AddressVeiwModel(id: documentId, docType: docType)
        } else {
            viewModel = AddressVeiwModel(id: UUID().uuidString, docType: docType)
        }
        view = AddressView()
        router = AddressRouter()
        viewModel?.router = router
        view?.viewModel = viewModel
        view?.searchBar.text = address
        AddressStep.searchCount = 0
        Request.addressNote.getNote(text: address) { [weak self] (data) in
            self?.viewModel?.dataArr = data
        }
    }
}
