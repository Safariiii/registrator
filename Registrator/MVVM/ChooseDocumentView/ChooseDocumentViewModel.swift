//
//  ChooseDocumentViewModel.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 29.07.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import Foundation
import Firebase

class ChooseDocumentViewModel {
    
    var documents: [Document] = []
    var reloadHandler: (() -> Void)?
    let firebaseService = FirebaseManager()
    
    init() {
        firebaseService.load { (documents) in
            self.documents = documents
            self.reloadHandler?()
        }
    }

    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRowsInSection() -> Int {
        return documents.count
    }
    
    func titleForHeaderInSection() -> String {
        return "Документы на регистрацию ИП"
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> ChooseDocumentCellViewModel? {
        let title = documents[indexPath.row].title
        let date = documents[indexPath.row].date
        
        return ChooseDocumentCellViewModel(title: title, date: date)
    }
    
    func showDocument(indexPath: IndexPath) {
        // TODO: - router here
        let documentId = indexPath.row == 0 ? nil : documents[indexPath.row].id
        MakeIPRouter.showModule(documentId: documentId)
        /*
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MakeIPViewController") as? MakeIPViewController, let nc = SceneDelegate.navigationController {
            if indexPath.row == 0 {
                vc.makeIPViewModel = MakeIPViewModel(id: UUID().uuidString, isNew: true)
            } else {
                vc.makeIPViewModel = MakeIPViewModel(id: documents[indexPath.row].id, isNew: false)
            }
            nc.pushViewController(vc, animated: true)
        }*/
    }
    
    func deleteDocument(indexPath: IndexPath) {
        let id = documents[indexPath.row].id
        firebaseService.deleteDocument(id: id)
    }
}
