//
//  MakeIPRouter.swift
//  Registrator
//
//  Created by Denis Khlopin on 29.09.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import UIKit

class MakeIPRouter {
    var nc: UINavigationController?
    
    static func showModule(/*nc: UINavigationController? = nil, */documentId: String? = nil) {
        let configurator = MakeIPConfigurator(documentId: documentId)
        //configurator.router?.nc = nc
        
        if let nc = SceneDelegate.navigationController, let vc = configurator.view {
        /*if let vc = configurator.view {
            let navController = nc ?? UINavigationController(rootViewController: vc)
            configurator.router?.nc = navController
            if nc == nil, let window = SceneDelegate.window {
                window.rootViewController = navController
                window.makeKeyAndVisible()
            }*/
            configurator.router?.nc = nc
            nc.pushViewController(vc, animated: true)
        }
    }
    
    func routeToPayment() {
        if let nc = nc {
            //PaymentRouter.showModule(nc)
        }
    }
}
//
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
