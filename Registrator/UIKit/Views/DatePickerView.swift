//
//  DatePickerView.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 27.09.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import UIKit

class DatePickerView: UIDatePicker {
    let extraLayer = UIView()
    var delegate: DatePickerDelegate?

    init() {
        super.init(frame: .zero)
        extraLayer.alpha = 0.5
        backgroundColor = .white
        datePickerMode = .date
        animatePickerView(y: -frame.height)
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        newSuperview?.addSubview(extraLayer)
        newSuperview?.endEditing(true)
        extraLayer.fillSuperview()
        extraLayer.backgroundColor = .lightGray
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissDatePickerView))
        extraLayer.addGestureRecognizer(tap)
    }
    
    override func didMoveToSuperview() {
        setupAnchors(top: superview?.bottomAnchor, leading: superview?.leadingAnchor, bottom: nil, trailing: superview?.trailingAnchor)
    }
    
    @objc func dismissDatePickerView() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        animatePickerView(y: 0)
        extraLayer.removeFromSuperview()
        removeFromSuperview()
        delegate?.didDismissDatePicker(text: formatter.string(from: date))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
