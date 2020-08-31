//
//  ChooseDocumentViewControllerCell.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 29.07.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import UIKit

class ChooseDocumentViewControllerCell: UITableViewCell {
    
    let docTitleLabel = UILabel()
    let docDateLabel = UILabel()
    let newDocButton = UIButton()
    let documentManager = DocumentManager(id: nil)
    var parentViewController: UIViewController?
    
    weak var viewModel: ChooseDocumentCellViewModel? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            newDocButton.removeFromSuperview()
            docTitleLabel.removeFromSuperview()
            docDateLabel.removeFromSuperview()
            if viewModel.indexPath.row == 0 {
                setupFirstButton()
                parentViewController = viewModel.parentViewController
            } else {
                setupLabels(viewModel: viewModel)
            }
            
            
        }
    }
    
    func setupLabels(viewModel: ChooseDocumentCellViewModel) {
        addSubview(docTitleLabel)
        addSubview(docDateLabel)
        
        docTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        docTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        docTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        docTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        docTitleLabel.text = viewModel.documents[viewModel.indexPath.row - 1].title
        docTitleLabel.numberOfLines = 0
        
        docDateLabel.translatesAutoresizingMaskIntoConstraints = false
        docDateLabel.topAnchor.constraint(equalTo: docTitleLabel.bottomAnchor,constant: 8).isActive = true
        docDateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        docDateLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        docDateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        docDateLabel.font = UIFont.systemFont(ofSize: 13)
        docDateLabel.textColor = .lightGray
        docDateLabel.text = viewModel.documents[viewModel.indexPath.row - 1].date
    }
    
    func setupFirstButton() {
        addSubview(newDocButton)
        newDocButton.translatesAutoresizingMaskIntoConstraints = false
        newDocButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        newDocButton.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        newDocButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        newDocButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
//        newDocButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        newDocButton.setTitleColor(.black, for: .normal)
        newDocButton.setTitle("Создать новый комплект документов", for: .normal)
        newDocButton.backgroundColor = .green
        newDocButton.addTarget(self, action: #selector(firstButtonPressed), for: .touchUpInside)
    }
    
    @objc func firstButtonPressed(sender: UIButton) {
        parentViewController?.performSegue(withIdentifier: "makeIP", sender: nil)
    }
    
}
