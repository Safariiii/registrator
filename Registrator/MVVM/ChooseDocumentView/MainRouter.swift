//
//  MainRouter.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 05.10.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import UIKit

class MainRouter {
    
    weak var nc: UINavigationController?
    
    static func showModule(nc: UINavigationController, type: DocType) {
        let configurator = MainConfigurator(type: type)
        configurator.router?.nc = nc
        if let vc = configurator.view {
            nc.pushViewController(vc, animated: true)
        }
    }
    
    func makeIPRoute(documentId: String?, type: DocType) {
        guard let nc = nc else { return }
        MakeIPRouter.showModule(nc: nc, documentId: documentId, type: type)
        
    }
}

class MainConfigurator {
    var viewModel: ChooseDocumentViewModel?
    var router: MainRouter?
    var view: ViewController?
    
    init(type: DocType) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as? ViewController {
            viewModel = ChooseDocumentViewModel(type: type)
            view = vc
            router = MainRouter()
            viewModel?.router = router
            view?.viewModel = viewModel
            OKVEDManager().checkForUpdates()
        }
    }
}
