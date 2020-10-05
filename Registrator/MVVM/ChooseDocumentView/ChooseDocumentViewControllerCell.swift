//
//  ChooseDocumentViewControllerCell.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 29.07.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import UIKit

class ChooseDocumentViewControllerCell: UITableViewCell {
    
    weak var viewModel: ChooseDocumentCellViewModel? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            backgroundColor = .white
            setupLabels(viewModel: viewModel)
        }
    }
    
    lazy var docTitleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var docDateLabel: UILabel = {
        let label = UILabel(textColor: .lightGray, fontSize: 13)
        return label
    }()
    
    lazy var plusImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "plus.circle"))
        imageView.tintColor = .red
        imageView.setSize(width: 30, height: 30)
        return imageView
    }()
    
    func setupLabels(viewModel: ChooseDocumentCellViewModel) {
        docTitleLabel.removeFromSuperview()
        docDateLabel.removeFromSuperview()
        docTitleLabel.text = viewModel.title
        if viewModel.title == "Создать новый комплект документов" {
            setupViewForFirstCell()
        } else {
            setupDefaultView(viewModel: viewModel)
        }
    }
    
    func setupViewForFirstCell() {
        backgroundColor = .systemGray5
        docTitleLabel.textAlignment = .center
        docTitleLabel.textColor = .black
        
        addSubview(plusImage)
        plusImage.setupAnchors(top: nil, leading: leadingAnchor, bottom: nil, trailing: nil, centerY: centerYAnchor, padding: .init(top: 0, left: 15, bottom: 0, right: 0))
        
        addSubview(docTitleLabel)
        docTitleLabel.setupAnchors(top: topAnchor, leading: plusImage.trailingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
    }
    
    func setupDefaultView(viewModel: ChooseDocumentCellViewModel) {
        addSubview(docTitleLabel)
        docTitleLabel.setupAnchors(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 10, left: 15, bottom: 0, right: 0))
        addSubview(docDateLabel)
        docDateLabel.setupAnchors(top: docTitleLabel.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 8, left: 15, bottom: -10, right: 0))
        docDateLabel.text = viewModel.date
    }
}
