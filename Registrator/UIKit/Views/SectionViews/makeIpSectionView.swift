//
//  makeIpSectionView.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 26.09.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import UIKit

class MakeIpSectionView: UIView {
    var viewModel: MakeIPViewModel
    
    lazy var makeIpSectionTitle: UIButton = {
        let button = UIButton(titleColor: .black, action: nil, target: nil)
        return button
    }()
    
    lazy var prevButton: UIButton = {
        let button = UIButton(action: #selector(prevButtonPressed), target: self, image: UIImage(systemName: "arrow.left"))
        button.tintColor = .black
        return button
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton(titleColor: .white, action: #selector(nextButtonPressed), target: self, image: UIImage(systemName: "arrow.right"))
        button.tintColor = .black
        
        return button
    }()
    
    init(viewModel: MakeIPViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        self.backgroundColor = .systemGreen
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        setupSectionTitle()
        let docType = viewModel.docType
        let step = viewModel.steps
        if step != docType.steps.first {
            setupPrevButton()
        }
        if step != docType.steps.last {
            setupNextButton()
        }
    }
    
    func setupSectionTitle() {
        makeIpSectionTitle.setTitle(viewModel.titleForHeaderInSection(), for: .normal)
        addSubview(makeIpSectionTitle)
        makeIpSectionTitle.fillSuperview()
    }
    
    func setupPrevButton() {
        addSubview(prevButton)
        prevButton.setupAnchors(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil, padding: .init(top: 0, left: 15, bottom: 0, right: 0))
    }
    
    func setupNextButton() {
        addSubview(nextButton)
        nextButton.setupAnchors(top: topAnchor, leading: nil, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: -15))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func nextButtonPressed() {
        let sv = superview as! UITableView
        sv.reloadData()
        viewModel.nextButtonPressed()
        sv.reloadData()
    }
    
    @objc func prevButtonPressed() {
        let sv = superview as! UITableView
        sv.reloadData()
        viewModel.prevButtonPressed()
        sv.reloadData()
    }
    
}
