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
    
    var router: MainRouter!
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
        let documentId = indexPath.row == 0 ? nil : documents[indexPath.row].id
        router.makeIPRoute(documentId: documentId)
    }
    
    func deleteDocument(indexPath: IndexPath) {
        let id = documents[indexPath.row].id
        firebaseService.deleteDocument(id: id)
    }
}
