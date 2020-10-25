//
//  OkvedSectionView.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 26.09.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import UIKit

class OkvedSectionView: UIView {
    let viewModel: OkvedTableViewViewModel
    
    let arrowImage: UIImageView = {
        let imageView = UIImageView()
        imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        imageView.image = UIImage(systemName: "chevron.down")
        imageView.tintColor = .red
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let okvedTitleLabel: UILabel = {
        let label = UILabel(fontSize: 15.5)
        return label
    }()
    
    let expandButton: UIButton = {
        let button = UIButton(action: #selector(expandButtonPressed), target: self)
        return button
    }()
    
    init(viewModel: OkvedTableViewViewModel, section: Int) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupSelf()
        setupArrowImage()
        setupOkvedTitleLabel(viewModel: viewModel, section: section)
        setupExpandButton(section: section)
    }
    
    func setupSelf() {
        layer.borderWidth = 0.3
        layer.borderColor = UIColor.black.cgColor
        heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        
    }
    
    func setupArrowImage() {
        addSubview(arrowImage)
        arrowImage.setupAnchors(top: topAnchor, leading: nil, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: -10))
    }
    
    func sectionBackgroundColor(viewModel: OkvedTableViewViewModel) -> UIColor {
        for item in viewModel.chosenCodes {
            if item.kod[0..<2] == okvedTitleLabel.text?[0..<2] {
                return .systemGray5
            }
        }
        return .white
    }
    
    func setupOkvedTitleLabel(viewModel: OkvedTableViewViewModel, section: Int) {
        okvedTitleLabel.text = viewModel.titleForHeaderInSection(section: section)
        addSubview(okvedTitleLabel)
        okvedTitleLabel.setupAnchors(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: arrowImage.leadingAnchor, padding: .init(top: 7, left: 10, bottom: -7, right: -10))
        if section == viewModel.openSection {
            backgroundColor = .red
            okvedTitleLabel.textColor = .white
        } else {
            backgroundColor = sectionBackgroundColor(viewModel: viewModel)
            okvedTitleLabel.textColor = .black
        }
        
    }
    
    func setupExpandButton(section: Int) {
        addSubview(expandButton)
        expandButton.fillSuperview()
        expandButton.tag = section
    }
    
    @objc func expandButtonPressed(sender: UIButton) {
        viewModel.getCodes(section: sender.tag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
