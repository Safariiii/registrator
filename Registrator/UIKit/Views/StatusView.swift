//
//  StatusView.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 14.10.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

enum StatusType: String {
    case send = "Идет подготовка и отправка документов..."
    case okvedUpdate = "Идет обновление кодов ОКВЭД. Это займет не более 1 минуты"
}

import UIKit

class StatusView: UIView {
    
    var status: StatusType

    init(status: StatusType) {
        self.status = status
        super.init(frame: .zero)
        backgroundColor = .systemGray5
        alpha = 0.8
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
        let label = UILabel(fontSize: 15, alignment: .center, numberOfLines: 0)
        label.text = self.status.rawValue
        return label
    }()
    
    func setupIndicator() {
        addSubview(indicator)
        indicator.setupAnchors(top: nil, leading: nil, bottom: nil, trailing: nil, centerX: centerXAnchor, centerY: centerYAnchor)
        indicator.startAnimating()
        addSubview(statusLabel)
        statusLabel.setupAnchors(top: nil, leading: leadingAnchor, bottom: indicator.topAnchor, trailing: trailingAnchor, centerX: centerXAnchor, padding: .init(top: 0, left: 0, bottom: -25, right: 0))
        
    }
    
    
    
}
