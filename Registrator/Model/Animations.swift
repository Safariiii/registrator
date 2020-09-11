//
//  Animations.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 24.07.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import UIKit


struct Animations {
    func animateTextLabels(textField: UITextField, y: CGFloat, tableView: UITableView) {
        guard let superview = textField.superview as? MakeIPTableViewCell else { return }
        let indexPath = tableView.indexPath(for: superview)
        if let indexPath = indexPath {
            guard let cell = tableView.cellForRow(at: indexPath) else { return }
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveLinear, animations: {
                cell.textLabel?.transform = CGAffineTransform(translationX: 0, y: y)                
            })
        }
    }
    
    func animatePickerView(pickerView: UIView, y: CGFloat) {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveLinear, animations: {
            pickerView.transform = CGAffineTransform(translationX: 0, y: y)
        })
    }
    
    func hideHelpView(view: UIView) {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveLinear, animations: {
            view.alpha = 0
        }){ (true) in
            view.removeFromSuperview()
        }
    
    }
}
