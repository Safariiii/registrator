//
//  LoginRouter.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 24.10.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import UIKit

class LoginRouter {
    weak var nc: UINavigationController?
    
    static var configurator: LoginConfigurator?
    
    static func showModule(nc: UINavigationController) {
        configurator = LoginConfigurator()
        configurator?.router?.nc = nc
        if let vc = configurator?.view {
            nc.pushViewController(vc, animated: true)
        }
    }
    
    func dismissModule() {
        if let nc = nc {
            nc.popToRootViewController(animated: true)
        }
    }

}

class LoginConfigurator {
    var viewModel: LoginViewModel?
    var router: LoginRouter?
    var view: LoginView?
    
    init() {
        viewModel = LoginViewModel()
        view = LoginView()
        router = LoginRouter()
        viewModel?.router = router
        view?.viewModel = viewModel
    }
}

