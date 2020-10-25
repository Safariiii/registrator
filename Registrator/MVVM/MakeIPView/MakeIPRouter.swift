//
//  MakeIPRouter.swift
//  Registrator
//
//  Created by Denis Khlopin on 29.09.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import UIKit

class MakeIPRouter {
    
    //static var nc: UINavigationController?
    weak var nc: UINavigationController?
    
    static func showModule(nc: UINavigationController, documentId: String? = nil, type: DocType) {
        let configurator = MakeIPConfigurator(documentId: documentId, type: type)
        configurator.router?.nc = nc
        if let vc = configurator.view {
            nc.pushViewController(vc, animated: true)
        }
    }
    
    func okvedRoute(okveds: [OKVED], id: String, mainOkved: String, collectionName: String) {
        guard let nc = nc else { return }
        OkvedRouter.showModule(nc: nc, okveds: okveds, id: id, mainOkved: mainOkved, collectionName: collectionName)
    }
    
    func addressRouter(id: String, address: String, docType: DocType) {
        guard let nc = nc else { return }
        AddressRouter.showModule(nc: nc, documentId: id, address: address, docType: docType)
    }
}

class MakeIPConfigurator {
    var viewModel: MakeIPViewModel?
    var router: MakeIPRouter?
    var view: MakeIPViewController?
    
    init(documentId: String?, type: DocType) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MakeIPViewController") as? MakeIPViewController {
            if let documentId = documentId {
                viewModel = MakeIPViewModel(id: documentId, isNew: false, type: type)
            } else {
                viewModel = MakeIPViewModel(id: UUID().uuidString, isNew: true, type: type)
            }
            view = vc
            router = MakeIPRouter()
            viewModel?.router = router
            view?.makeIPViewModel = viewModel
        }
    }
}
