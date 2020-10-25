//
//  OkvedRouter.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 05.10.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import UIKit

class OkvedRouter {
    weak var nc: UINavigationController?
    
    static var configurator: OkvedConfigurator?
    
    static func showModule(nc: UINavigationController, okveds: [OKVED], id: String, mainOkved: String, collectionName: String) {
        
        configurator = OkvedConfigurator(okveds: okveds, id: id, mainOkved: mainOkved, collectionName: collectionName)
        configurator?.router?.nc = nc
        if let vc = configurator?.view {
            nc.present(vc, animated: true, completion: nil)
        }
    }
    
    func dismissModule() {
        if let vc = OkvedRouter.configurator?.view {
            vc.dismiss(animated: true, completion: nil)
        }
    }
}

class OkvedConfigurator {
    var viewModel: OkvedTableViewViewModel?
    var router: OkvedRouter?
    var view: OkvedView?
    
    init(okveds: [OKVED], id: String, mainOkved: String, collectionName: String) {
        viewModel = OkvedTableViewViewModel(okveds: okveds, id: id, mainOkved: mainOkved, collectionName: collectionName)
        view = OkvedView()
        router = OkvedRouter()
        viewModel?.router = router
        view?.viewModel = viewModel!
    }
}
