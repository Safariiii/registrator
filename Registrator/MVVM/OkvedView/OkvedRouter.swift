//
//  OkvedRouter.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 05.10.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import UIKit

class OkvedRouter {
    static var nc: UINavigationController?
    
    static var configurator: OkvedConfigurator?
    
    static func showModule(nc: UINavigationController, okveds: [OKVED], id: String) {
        self.nc = nc
        configurator = OkvedConfigurator(okveds: okveds, id: id)
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
    
    init(okveds: [OKVED], id: String) {
        viewModel = OkvedTableViewViewModel(okveds: okveds, id: id)
        view = OkvedView()
        router = OkvedRouter()
        viewModel?.router = router
        view?.viewModel = viewModel!
    }
}
