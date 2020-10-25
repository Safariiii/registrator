//
//  NoteView.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 12.10.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

fileprivate let osnoText = "Общая (традиционная) система налогообложения (сокращ. ОСН или ОСНО) - вид налогообложения, при котором организациями в полном объеме ведется бухгалтерский учет и уплачиваются все общие налоги НДС, налог на прибыль организаций, налог на имущество организаций). Бухгалтерский учет при ОСН ведется с использованием Плана счетов."
fileprivate let usnText = "Упрощенная система налогообложения (УСН, «упрощенка») — это специальный режим налогообложения, при котором ИП или юрлицо освобождается от уплаты налогов на прибыль и имущество, НДФЛ и НДС (кроме импортного).Компания на УСН платит лишь один налог. Необходимо только выбрать один из двух вариантов процентной ставки: 6 % от доходов или 5–15 % от разницы между доходами и расходами (ставка зависит от региона и вида деятельности).Чтобы определить, какой режим подойдет вам, оцените, высоки ли ваши расходы, которые вы сможете документально подтвердить. Если они составляют менее половины выручки, вам рекомендуется выбрать 6 % от доходов. В случае если расходы составляют половину или более от выручки, выгоднее выбрать 15 % от разницы доходы минус расходы."
fileprivate let closeButtonTitle = "Понятно"

import UIKit

class NoteView: UIView {
    init() {
        super.init(frame: .zero)
        layer.borderColor = UIColor.systemGreen.cgColor
        layer.borderWidth = 1
        backgroundColor = .white
        setupCloseButton()
        setupNoteLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        setupAnchors(top: superview?.safeAreaLayoutGuide.topAnchor, leading: superview?.leadingAnchor, bottom: superview?.safeAreaLayoutGuide.bottomAnchor, trailing: superview?.trailingAnchor, padding: .init(top: 30, left: 20, bottom: -30, right: -20))
    }
    
    lazy var closeButton: UIButton = {
        let button = UIButton(title: closeButtonTitle, titleColor: .black, backgroundColor: .systemGreen, action: #selector(closeButtonPressed), target: self, targetEvent: .touchUpInside, cornerRadius: 7, fontSize: 15, numberOfLines: 1, textAlignment: .center)
        return button
    }()
    
    func setupCloseButton() {
        addSubview(closeButton)
        closeButton.setupAnchors(top: nil, leading: nil, bottom: bottomAnchor, trailing: nil, centerX: centerXAnchor, padding: .init(top: 0, left: 0, bottom: -20, right: 0))
        closeButton.setSize(width: 130, height: 40)
    }
    
    func setupNoteLabel() {
        let osnoLabel = UILabel(text: osnoText, fontSize: 13, alignment: .justified, numberOfLines: 0)
        addSubview(osnoLabel)
        osnoLabel.setupAnchors(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 8, left: 8, bottom: 0, right: -8))
        
        let usnLabel = UILabel(text: usnText, fontSize: 13, alignment: .justified, numberOfLines: 0)
        addSubview(usnLabel)
        usnLabel.setupAnchors(top: osnoLabel.bottomAnchor, leading: leadingAnchor, bottom: closeButton.topAnchor, trailing: trailingAnchor, padding: .init(top: 10, left: 8, bottom: -12, right: -8))
    }
    
    @objc func closeButtonPressed() {
        removeFromSuperview()
    }
}
