//
//  DocumentMaster.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 03.08.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import UIKit

class DocumentMaster {
    let helpView = UIView()
    let animations = Animations()
    
    func setupHelpView(parentView: UIView) {
        parentView.addSubview(helpView)
        helpView.translatesAutoresizingMaskIntoConstraints = false
        helpView.topAnchor.constraint(equalTo: parentView.topAnchor).isActive = true
        helpView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor).isActive = true
        helpView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor).isActive = true
        helpView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor).isActive = true
        helpView.backgroundColor = .white
        
        let helpTextLabel = UILabel()
        helpView.addSubview(helpTextLabel)
        helpTextLabel.translatesAutoresizingMaskIntoConstraints = false
        helpTextLabel.textColor = .black
        helpTextLabel.translatesAutoresizingMaskIntoConstraints = false
        helpTextLabel.centerYAnchor.constraint(equalTo: helpView.centerYAnchor, constant: -150).isActive = true
        
        helpTextLabel.leadingAnchor.constraint(equalTo: helpView.leadingAnchor).isActive = true
        helpTextLabel.trailingAnchor.constraint(equalTo: helpView.trailingAnchor).isActive = true
        helpTextLabel.text = "Мастер подготовки документов"
        helpTextLabel.font = UIFont.systemFont(ofSize: 21, weight: .semibold)
        helpTextLabel.textAlignment = .center
        helpTextLabel.numberOfLines = 0
        
        let secondHelpTextLabel = UILabel()
        helpView.addSubview(secondHelpTextLabel)
        secondHelpTextLabel.translatesAutoresizingMaskIntoConstraints = false
        secondHelpTextLabel.leadingAnchor.constraint(equalTo: helpView.leadingAnchor, constant: 10).isActive = true
        secondHelpTextLabel.trailingAnchor.constraint(equalTo: helpView.trailingAnchor, constant: -10).isActive = true
        secondHelpTextLabel.topAnchor.constraint(equalTo: helpTextLabel.bottomAnchor, constant: 15).isActive = true
        secondHelpTextLabel.text = "Для успешной подготовки документов, введите необходимую информацию в Мастер подготовки документов. При заполнении паспортных данных вводите информацию точно также как она указана в паспорте (не используйте сокращений или других склонений)."
        secondHelpTextLabel.textAlignment = .justified
        secondHelpTextLabel.numberOfLines = 0
        secondHelpTextLabel.font = UIFont.systemFont(ofSize: 14)
        
        let beginButton = UIButton()
        helpView.addSubview(beginButton)
        beginButton.translatesAutoresizingMaskIntoConstraints = false
        beginButton.topAnchor.constraint(equalTo: secondHelpTextLabel.bottomAnchor, constant: 35).isActive = true
        beginButton.leadingAnchor.constraint(equalTo: helpView.leadingAnchor, constant: 65).isActive = true
        beginButton.trailingAnchor.constraint(equalTo: helpView.trailingAnchor, constant: -65).isActive = true
        beginButton.setTitle("Начать", for: .normal)
        beginButton.setTitleColor(.white, for: .normal)
        beginButton.backgroundColor = .red
        beginButton.layer.cornerRadius = 7
        beginButton.addTarget(self, action: #selector(beginButtonPressed), for: .touchUpInside)
    }
    
    @objc func beginButtonPressed() {
        animations.hideHelpView(view: helpView)
    }
}
