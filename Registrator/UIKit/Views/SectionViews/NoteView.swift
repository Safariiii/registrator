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
fileprivate let usnLabelText = """
1) Выберите "С момента регистрации ИП" если: Вы индивидуальный предприниматель, подающий уведомление одновременно с документами на государственную регистрацию ИП;

2) Выберите "Не более 30 дней после регистрации ИП" если: С момента регистрации вашего ИП прошло не более 30-ти дней (подать уведомление будет необходимо до истечения 30-ти дней с момента регистрации вашего ИП);

3) Выберите "C 1-го числа следующего месяца" если: Вы индивидуальный предприниматель, который решил перейти с ЕНВД на упрощенную систему налогообложения;

4) Выберите "С 1-го января следующего года" если: Вы индивидуальный предприниматель, переходящий с иных режимов налогообложения, кроме ЕНВД.
"""

import UIKit

class NoteView: UIView {
    
    init(type: TextFieldType) {
        super.init(frame: .zero)
        layer.borderColor = UIColor.systemGreen.cgColor
        layer.borderWidth = 1
        backgroundColor = .white
        setupCloseButton()
        if type == .taxesSystem {
            setupTaxLabel()
        } else if type == .usnGiveTime {
            setupUSNLabel()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        setupAnchors(top: nil, leading: superview?.leadingAnchor, bottom: nil, trailing: superview?.trailingAnchor, centerX: superview?.centerXAnchor, centerY: superview?.centerYAnchor, padding: .init(top: 0, left: 20, bottom: 0, right: -20))
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
    
    func setupTaxLabel() {
        let osnoLabel = UILabel(text: osnoText, fontSize: 13, alignment: .natural, numberOfLines: 0)
        addSubview(osnoLabel)
        osnoLabel.setupAnchors(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 8, left: 8, bottom: 0, right: -8))
        
        let usnLabel = UILabel(text: usnText, fontSize: 13, alignment: .natural, numberOfLines: 0)
        addSubview(usnLabel)
        usnLabel.setupAnchors(top: osnoLabel.bottomAnchor, leading: leadingAnchor, bottom: closeButton.topAnchor, trailing: trailingAnchor, padding: .init(top: 20, left: 8, bottom: -12, right: -8))
    }
    
    func setupUSNLabel() {
        let label = UILabel(text: usnLabelText, fontSize: 14, alignment: .natural, numberOfLines: 0)
        addSubview(label)
        label.setupAnchors(top: topAnchor, leading: leadingAnchor, bottom: closeButton.topAnchor, trailing: trailingAnchor, padding: .init(top: 8, left: 8, bottom: -8, right: -12))
    }
    
    @objc func closeButtonPressed() {
        removeFromSuperview()
    }
}
