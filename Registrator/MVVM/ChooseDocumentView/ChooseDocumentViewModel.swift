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
    var docType: DocType
    
    init(type: DocType) {
        self.docType = type
        docType.load { [weak self] (documents) in
            self?.documents = documents
            self?.reloadHandler?()
        }
        
    }

    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRowsInSection() -> Int {
        return documents.count
    }
    
    var viewControllerTitle: String {
        return docType.rawValue
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> ChooseDocumentCellViewModel? {
        let title = documents[indexPath.row].title
        let date = documents[indexPath.row].date
        return ChooseDocumentCellViewModel(title: title, date: date)
    }
    
    func showDocument(indexPath: IndexPath) {
        let documentId = indexPath.row == 0 ? nil : documents[indexPath.row].id
        router.makeIPRoute(documentId: documentId, type: docType)
    }
    
    func deleteDocument(indexPath: IndexPath) {
        let id = documents[indexPath.row].id
        docType.delete(id: id)
    }
}
