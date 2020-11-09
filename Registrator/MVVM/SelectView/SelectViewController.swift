//
//  SelectViewController.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 06.10.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

fileprivate let welcomeText = "Добро пожаловать в REGISTRATOR - самый простой и удобный сервис для подготовки документов для регистрации и ликвидации ИП!"
fileprivate let secondWelcomeText = "Для начала работы нажмите нужную Вам кнопку и следуйте инструкциям. Весь процесс займет не более 15 минут. До 25 ноября 2020 г. наш сервис работает абсолютно БЕСПЛАТНО!"
fileprivate let screentitle = "REGISTRATOR"
fileprivate let deleteIPButtonTitle = "Ликвидировать ИП"
fileprivate let makeIPButtonTitle = "Зарегистрировать ИП"
fileprivate let iWantIPLabelText = "Я хочу:"

import UIKit
import FirebaseAuth

class SelectViewController: UIViewController {

    var viewModel: SelectViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        view.backgroundColor = .white
        title = screentitle
        setupSettingsButton()
        setupWelcomeLabel()
        if Auth.auth().currentUser == nil {
            viewModel?.goToLoginView()
        }
    }
    
    //MARK: - makeDocButton
    var makeDocButton: UIButton {
        let button = UIButton(backgroundColor: .systemGreen, action: nil, target: nil, cornerRadius: 5, fontSize: 18, numberOfLines: 1, textAlignment: .center, image: nil)
        button.drawShadow()
        return button
    }
    
    @objc func makeDocButtonPressed(sender: UIButton) {
        guard let viewModel = viewModel else { return }
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear, animations: {
            sender.transform = CGAffineTransform(translationX: -6, y: 8)
            sender.layer.shadowOpacity = 0
        }) { (true) in
            viewModel.makeDocButtonPressed(tag: sender.tag)
            sender.transform = CGAffineTransform(translationX: 0, y: 0)
            sender.layer.shadowOpacity = 0.5
        }
    }
    
    func setupDocButton() {
        guard let viewModel = viewModel else { return }
        var buttonsArray = [UIButton]()
        viewModel.createButtons { [weak self] (title, position) in
            guard let self = self else { return }
            let btn = self.makeDocButton
            self.view.addSubview(btn)
            btn.setTitle(title, for: .normal)
            btn.setSize(width: 215, height: 45)
            btn.addTarget(self, action: #selector(self.makeDocButtonPressed), for: .touchUpInside)
            btn.tag = buttonsArray.count
            if buttonsArray.count == 0 {
                btn.setupAnchors(top: self.iWantLabel.bottomAnchor, leading: nil, bottom: nil, trailing: self.view.trailingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: -10))
            } else {
                if position == .right {
                    btn.setupAnchors(top: buttonsArray.last?.bottomAnchor, leading: nil, bottom: nil, trailing: self.view.trailingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: -10))
                } else if position == .left {
                    btn.setupAnchors(top: buttonsArray.last?.bottomAnchor, leading: self.view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 20, left: 10, bottom: 0, right: 0))
                }
            }
            buttonsArray.append(btn)
        }
    }
    
    //MARK: - WelcomeLabel
    
    lazy var welcomeLabel: UILabelPadding = {
        let label = UILabelPadding(text: welcomeText, textColor: .black, fontSize: 15, fontWeight: .regular, alignment: .left, numberOfLines: 0)
        label.backgroundColor = .systemGreen
        label.layer.cornerRadius = 10
        label.drawShadow()
        return label
    }()
    
    func setupWelcomeLabel() {
        view.addSubview(welcomeLabel)
        welcomeLabel.setupAnchors(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 30, left: 80, bottom: 0, right: -10))
        welcomeLabel.transform = CGAffineTransform(translationX: 600, y: 0)
        UIView.animate(withDuration: 0.7, delay: 0, options: .curveLinear, animations: {
            self.welcomeLabel.transform = CGAffineTransform(translationX: 0, y: 0)
        }) { (true) in
            self.setupSecondWelcomeLabel()
        }
    }
    
    //MARK: - SecondWelcomeLabel
    
    lazy var secondWelcomeLabel: UILabelPadding = {
        let label = UILabelPadding(text: secondWelcomeText, fontSize: 15, alignment: .left, numberOfLines: 0)
        label.backgroundColor = .systemGreen
        label.layer.cornerRadius = 10
        label.drawShadow()
        return label
    }()
    
    
    func setupSecondWelcomeLabel() {
        view.addSubview(secondWelcomeLabel)
        secondWelcomeLabel.setupAnchors(top: welcomeLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 20, left: 10, bottom: 0, right: -80))
        secondWelcomeLabel.transform = CGAffineTransform(translationX: -600, y: 0)
        UIView.animate(withDuration: 0.7, delay: 0, options: .curveLinear, animations: {
            self.secondWelcomeLabel.transform = CGAffineTransform(translationX: 0, y: 0)
        }) { (true) in
            self.setupIwantLabel()
        }
    }
    
    //MARK: - iWantLabel
    
    lazy var iWantLabel: UILabel = {
        let label = UILabel(text: iWantIPLabelText, textColor: .black, fontSize: 23, fontWeight: .semibold, alignment: .center, numberOfLines: 0)
        return label
    }()
    
    func setupIwantLabel() {
        view.addSubview(iWantLabel)
        iWantLabel.setupAnchors(top: secondWelcomeLabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil, centerX: view.centerXAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 0))
        iWantLabel.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear, animations: {
            self.iWantLabel.alpha = 1
        }) { (true) in
            self.setupDocButton()
        }
    }
    
    //MARK: - LogoutButton
    
    
    
    //MARK: - SettingsButton
    
    lazy var settingsButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "paperclip"), style: .plain, target: self, action: #selector(settingsButtonPressed))
        button.tintColor = .black
        return button
    }()
    
    @objc func settingsButtonPressed() {
        guard let nc = navigationController else { return }
        let sv = SettingsView(nc: nc)
        view.addSubview(sv)
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        sv.disable = { [weak self] in
            self?.navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    func setupSettingsButton() {
        self.navigationItem.rightBarButtonItem = settingsButton
        
    }
    
}
