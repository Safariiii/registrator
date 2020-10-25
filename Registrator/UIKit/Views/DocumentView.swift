//
//  DocumentView.swift
//  
//
//  Created by Denis Khlopin on 02.09.2020.
//

import UIKit

fileprivate let secondHelpText = NSLocalizedString(
    "Для успешной подготовки документов, введите необходимую информацию в Мастер подготовки документов. При заполнении паспортных данных вводите информацию точно также как она указана в паспорте (не используйте сокращений или других склонений, заполняйте поля в точности до каждой запятой и точки). "
    , comment: "")
fileprivate let helpText = "Мастер подготовки документов"
fileprivate let buttonTitle = "Начать"

class DocumentView: UIView {
    lazy var helpTextLabel: UILabel = {
        let label = UILabel(text: helpText, textColor: .black, fontSize: 21, fontWeight: .semibold, alignment: .center)
        return label
    }()
    
    lazy var secondHelpTextLabel: UILabel = {
        let text = secondHelpText
        let label = UILabel(text: text, fontSize: 14, alignment: .justified)
        return label
    }()
    
    lazy var beginButton: UIButton = {
        let button = UIButton(
            title: buttonTitle,
            titleColor: .white,
            backgroundColor: .systemGreen,
            action: #selector(beginButtonPressed),
            target: self,
            cornerRadius: 7)
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        setupHelpTextLabel()
        setupSecondHelpTextLabel()
        setupBeginButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupHelpTextLabel() {
        self.addSubview(helpTextLabel)
        helpTextLabel.setupAnchors(top: nil, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
        helpTextLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -150).isActive = true
    }
    
    func setupSecondHelpTextLabel() {
        self.addSubview(secondHelpTextLabel)
        secondHelpTextLabel.setupAnchors(top: helpTextLabel.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 15, left: 10, bottom: 0, right: -10))
    }
    
    func setupBeginButton() {
        self.addSubview(beginButton)
        beginButton.setupAnchors(top: secondHelpTextLabel.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 35, left: 65, bottom: 0, right: -65))
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.fillSuperview()
    }
    
    @objc func beginButtonPressed() {
        self.hideAndRemoveViewFromSuperview()
    }
}
