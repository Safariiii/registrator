//
//  SelectRouter.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 06.10.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import UIKit

class SelectRouter {
    
    weak var nc: UINavigationController?
    
    static func showModule() {
        let configurator = SelectConfigurator()
        
        if let vc = configurator.view {
            let nc = UINavigationController(rootViewController: vc)
            configurator.router?.nc = nc
            SceneDelegate.window?.rootViewController = nc
            SceneDelegate.window?.makeKeyAndVisible()
        }
    }
    
    func chooseDocumentRoute(type: DocType) {
        guard let nc = nc else { return }
        MainRouter.showModule(nc: nc, type: type)
    }
    
    func loginRoute() {
        guard let nc = nc else { return }
        LoginRouter.showModule(nc: nc)
    }
}

class SelectConfigurator {
    var viewModel: SelectViewModel?
    var router: SelectRouter?
    var view: SelectViewController?
    
    init() {
        viewModel = SelectViewModel()
        view = SelectViewController()
        router = SelectRouter()
        viewModel?.router = router
        view?.viewModel = viewModel
    }
}
