//
//  StatusView.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 14.10.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

fileprivate let statusTitle = "Идет подготовка и отправка документов..."

import UIKit

class StatusView: UIView {

    init() {
        super.init(frame: .zero)
        backgroundColor = .systemGray5
        alpha = 0.5
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        fillSuperview()
        setupIndicator()
    }
    
    let indicator = UIActivityIndicatorView(style: .large)
    
    lazy var statusLabel: UILabel = {
        let label = UILabel(text: statusTitle, fontSize: 15, alignment: .center, numberOfLines: 1)
        return label
    }()
    
    func setupIndicator() {
        addSubview(indicator)
        indicator.setupAnchors(top: nil, leading: nil, bottom: nil, trailing: nil, centerX: centerXAnchor, centerY: centerYAnchor)
        indicator.startAnimating()
        addSubview(statusLabel)
        statusLabel.setupAnchors(top: nil, leading: nil, bottom: indicator.topAnchor, trailing: nil, centerX: centerXAnchor, padding: .init(top: 0, left: 0, bottom: -25, right: 0))
        
    }
    
    
    
}
