//
//  TableViewCell+Extension.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 23.09.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import UIKit

extension UITableViewCell {
    func animateCellTextLabel(y: CGFloat) {
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1,
            options: .curveLinear,
            animations: {
            self.textLabel?.transform = CGAffineTransform(translationX: 0, y: y)
        })
    }
}
