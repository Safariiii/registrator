//
//  ChooseDocumentViewModel.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 29.07.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import UIKit
import Firebase

class ChooseDocumentViewModel {
    
//    private var documentManager: DocumentManager
    private let db: Firestore
    var documents: [Document] = []
    var tableView: UITableView
    var parentViewController: UIViewController
    var chosenDocument: Int?
    
    init(tableView: UITableView, parentViewController: UIViewController) {
        self.tableView = tableView
        db = Firestore.firestore()
        self.parentViewController = parentViewController
        load()
    }
    
    private func load() {
        self.db.collection("documents").document("CurrentUser").collection("IP").addSnapshotListener { (querySnapshot, error) in
            self.documents = []
            guard let snapshot = querySnapshot else { return }
            for doc in snapshot.documents {
                let data = doc.data()
                if let lastName = data["lastName"] as? String, let firstName = data["firstName"] as? String, let middleName = data["middleName"] as? String {
                    let title = "\(lastName) \(firstName) \(middleName)"
                    let date = data["dateOfBirth"] as! String
                    self.documents.append(Document(id: doc.documentID, title: title, date: date))
                }
            }
            self.tableView.reloadData()
        }
    }

    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRowsInSection() -> Int {
        return documents.count + 1
    }
    
    func titleForHeaderInSection() -> String {
        return "Документы на регистрацию ИП"
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath, documents: [Document]) -> ChooseDocumentCellViewModel? {
        return ChooseDocumentCellViewModel(documents: documents, indexPath: indexPath, parentViewController: parentViewController)
    }
    
    func showDocument(indexPath: IndexPath) {
        self.chosenDocument = indexPath.row - 1
        if indexPath.row == 0 {
            parentViewController.performSegue(withIdentifier: "makeIP", sender: nil)
        } else {
            parentViewController.performSegue(withIdentifier: "openIP", sender: nil)
        }
        
    }
}
