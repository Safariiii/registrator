//
//  DocumentView.swift
//  
//
//  Created by Denis Khlopin on 02.09.2020.
//

import UIKit

class DocumentView: UIView {

    let viewModel: DocumentViewModel
    
    let animations = Animations()
    
    lazy var helpTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.text = "Мастер подготовки документов"
        label.font = UIFont.systemFont(ofSize: 21, weight: .semibold)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    init(viewModel: DocumentViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() {
        self.addSubview(helpTextLabel)
        helpTextLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -150).isActive = true
        helpTextLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        helpTextLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true

        let secondHelpTextLabel = UILabel()
        self.addSubview(secondHelpTextLabel)
        secondHelpTextLabel.translatesAutoresizingMaskIntoConstraints = false
        secondHelpTextLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        secondHelpTextLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        secondHelpTextLabel.topAnchor.constraint(equalTo: helpTextLabel.bottomAnchor, constant: 15).isActive = true
        secondHelpTextLabel.text = "Для успешной подготовки документов, введите необходимую информацию в Мастер подготовки документов. При заполнении паспортных данных вводите информацию точно также как она указана в паспорте (не используйте сокращений или других склонений)."
        secondHelpTextLabel.textAlignment = .justified
        secondHelpTextLabel.numberOfLines = 0
        secondHelpTextLabel.font = UIFont.systemFont(ofSize: 14)
        
        let beginButton = UIButton()
        self.addSubview(beginButton)
        beginButton.translatesAutoresizingMaskIntoConstraints = false
        beginButton.topAnchor.constraint(equalTo: secondHelpTextLabel.bottomAnchor, constant: 35).isActive = true
        beginButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 65).isActive = true
        beginButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -65).isActive = true
        beginButton.setTitle("Начать", for: .normal)
        beginButton.setTitleColor(.white, for: .normal)
        beginButton.backgroundColor = .red
        beginButton.layer.cornerRadius = 7
        beginButton.addTarget(self, action: #selector(beginButtonPressed), for: .touchUpInside)
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard let superview = superview else {
            return
        }
        setupHelpView(parentView: superview)
    }
       
       func setupHelpView(parentView: UIView) {
           //parentView.addSubview(self)
           translatesAutoresizingMaskIntoConstraints = false
           topAnchor.constraint(equalTo: parentView.topAnchor).isActive = true
           leadingAnchor.constraint(equalTo: parentView.leadingAnchor).isActive = true
           trailingAnchor.constraint(equalTo: parentView.trailingAnchor).isActive = true
           bottomAnchor.constraint(equalTo: parentView.bottomAnchor).isActive = true
           backgroundColor = .white
       }
       
       @objc func beginButtonPressed() {
           animations.hideHelpView(view: self)
       }

}

class DocumentViewModel {
    
}
