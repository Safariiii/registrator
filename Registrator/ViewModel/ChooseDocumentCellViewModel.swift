//
//  ChooseDocumentCellViewModel.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 29.07.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import UIKit

class ChooseDocumentCellViewModel {
    var documents: [Document]
    var indexPath: IndexPath
    var parentViewController: UIViewController

    init(documents: [Document], indexPath: IndexPath, parentViewController: UIViewController) {
        self.documents = documents
        self.indexPath = indexPath
        self.parentViewController = parentViewController
    }
    
}
