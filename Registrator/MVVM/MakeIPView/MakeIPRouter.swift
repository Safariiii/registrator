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
    
    static func showModule(nc: UINavigationController, documentId: String? = nil) {
        let configurator = MakeIPConfigurator(documentId: documentId)
        configurator.router?.nc = nc
        if let vc = configurator.view {
            nc.pushViewController(vc, animated: true)
        }
    }
    
    func okvedRoute(okveds: [OKVED], id: String) {
        guard let nc = nc else { return }
        OkvedRouter.showModule(nc: nc, okveds: okveds, id: id)
    }
}

class MakeIPConfigurator {
    var viewModel: MakeIPViewModel?
    var router: MakeIPRouter?
    var view: MakeIPViewController?
    
    init(documentId: String?) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MakeIPViewController") as? MakeIPViewController {
            if let documentId = documentId {
                viewModel = MakeIPViewModel(id: documentId, isNew: false)
            } else {
                viewModel = MakeIPViewModel(id: UUID().uuidString, isNew: true)
            }
            view = vc
            router = MakeIPRouter()
            viewModel?.router = router
            view?.makeIPViewModel = viewModel
        }
    }
}
