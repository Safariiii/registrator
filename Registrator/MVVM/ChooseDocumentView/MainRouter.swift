//
//  MainRouter.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 05.10.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import UIKit

class MainRouter {
    
//    static var nc: UINavigationController?
    weak var nc: UINavigationController?
    
    static func showModule() {
        let configurator = MainConfigurator()
        
        if let vc = configurator.view {
            let nc = UINavigationController(rootViewController: vc)
            configurator.router?.nc = nc
            SceneDelegate.window?.rootViewController = nc
            SceneDelegate.window?.makeKeyAndVisible()
        }
    }
    
    func makeIPRoute(documentId: String?) {
        guard let nc = nc else { return }
        MakeIPRouter.showModule(nc: nc, documentId: documentId)
        
    }
}

class MainConfigurator {
    var viewModel: ChooseDocumentViewModel?
    var router: MainRouter?
    var view: ViewController?
    
    init() {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as? ViewController {
            viewModel = ChooseDocumentViewModel()
            view = vc
            router = MainRouter()
            viewModel?.router = router
            view?.viewModel = viewModel
        }
    }
}
