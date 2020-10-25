//
//  SelectViewController.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 06.10.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

fileprivate let welcomeText = "Добро пожаловать в REGISTRATOR - самый простой и удобный сервис для подготовки документов для регистрации и ликвидации ИП!"
fileprivate let secondWelcomeText = "Для начала работы нажмите нужную Вам кнопку и следуйте инструкциям. Весь процесс займет не более 15 минут."
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
        setupWelcomeLabel()
        if Auth.auth().currentUser == nil {
            viewModel?.goToLoginView()
        }
    }
    
    //MARK: - makeIPButton
    
    lazy var makeIpButton: UIButton = {
        let button = UIButton(title: makeIPButtonTitle, backgroundColor: .systemGreen, action: #selector(makeIpButtonPressed), target: self, cornerRadius: 5, fontSize: 18, numberOfLines: 1, textAlignment: .center, image: nil)
        button.drawShadow()
        return button
    }()
    
    @objc func makeIpButtonPressed() {
        guard let viewModel = viewModel else { return }
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear, animations: {
            self.makeIpButton.transform = CGAffineTransform(translationX: -6, y: 8)
            self.makeIpButton.layer.shadowOpacity = 0
        }) { (true) in
            viewModel.makeIpButtonPressed()
            self.makeIpButton.transform = CGAffineTransform(translationX: 0, y: 0)
            self.makeIpButton.layer.shadowOpacity = 0.5
        }
    }
    
    func setupMakeIpButton() {
        view.addSubview(makeIpButton)
        makeIpButton.setupAnchors(top: iWantLabel.bottomAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: -10))
        makeIpButton.setSize(width: 215, height: 45)
    }
    
    //MARK: - deleteIPButton
    
    lazy var deleteIpButton: UIButton = {
        let button = UIButton(title: deleteIPButtonTitle, backgroundColor: .systemGreen, action: #selector(deleteIpButtonPressed), target: self, cornerRadius: 5, fontSize: 20, numberOfLines: 1, textAlignment: .center, image: nil)
        button.drawShadow()
        return button
    }()
    
    @objc func deleteIpButtonPressed() {
        guard let viewModel = viewModel else { return }
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear, animations: {
            self.deleteIpButton.transform = CGAffineTransform(translationX: -6, y: 8)
            self.deleteIpButton.layer.shadowOpacity = 0
        }) { (true) in
            viewModel.deleteIpButtonPressed()
            self.deleteIpButton.transform = CGAffineTransform(translationX: 0, y: 0)
            self.deleteIpButton.layer.shadowOpacity = 0.5
        }
    }
    
    func setupDeleteIpButton() {
        view.addSubview(deleteIpButton)
        deleteIpButton.setupAnchors(top: makeIpButton.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 20, left: 10, bottom: 0, right: 0))
        deleteIpButton.setSize(width: 215, height: 45)
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
            self.setupMakeIpButton()
            self.setupDeleteIpButton()
            self.setupLogoutButton()
        }
    }
    
    //MARK: - LogoutButton
    
    lazy var logoutLabel: UILabel = {
        guard let email = Auth.auth().currentUser?.email else { return UILabel() }
        let label = UILabel(text: "Вы вошли как: \(email)")
        return label
    }()
    
    lazy var logoutButton: UIButton = {
        let button = UIButton(title: "Выйти", titleColor: .link, action: #selector(logoutButtonPressed), target: self, image: nil)
        return button
    }()
    
    @objc func logoutButtonPressed() {
        guard let viewModel = viewModel else { return }
        viewModel.logoutButtonPressed()
    }
    
    func setupLogoutButton() {
        let sv = UIStackView(arrangedSubviews: [logoutLabel, logoutButton])
        sv.alignment = .center
        sv.axis = .vertical
        view.addSubview(sv)
        sv.setupAnchors(top: nil, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: nil, centerX: view.centerXAnchor, padding: .init(top: 0, left: 0, bottom: -30, right: 0))
        
    }
}
