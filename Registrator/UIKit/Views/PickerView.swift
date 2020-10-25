//
//  PickerView.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 27.09.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import UIKit

class PickerView: UIPickerView {
    let extraLayer = UIView()
    
    init() {
        super.init(frame: .zero)
        extraLayer.alpha = 0.5
        backgroundColor = .white
        alpha = 1
        animatePickerView(y: -frame.height)
    }
    
    override func didMoveToSuperview() {
        setupAnchors(top: superview?.bottomAnchor, leading: superview?.leadingAnchor, bottom: nil, trailing: superview?.trailingAnchor)
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        newSuperview?.addSubview(extraLayer)
        newSuperview?.endEditing(true)
        extraLayer.fillSuperview()
        extraLayer.backgroundColor = .lightGray
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissPickerView))
        extraLayer.addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func dismissPickerView() {
        animatePickerView(y: 0)
        extraLayer.removeFromSuperview()
        removeFromSuperview()
    }
}
