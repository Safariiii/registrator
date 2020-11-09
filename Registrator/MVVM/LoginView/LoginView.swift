//
//  LoginView.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 24.10.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

fileprivate let mainTitle = "Registrator"
fileprivate let reg = "Регистрация"
fileprivate let auth = "Авторизация"

import UIKit
import FirebaseAuth

class LoginView: UIViewController {
    var viewModel: LoginViewModel?
    
    override func viewDidLoad() {
        setupView()
    }
    
    lazy var segmentControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: [reg, auth])
        sc.selectedSegmentIndex = 0
        sc.heightAnchor.constraint(equalToConstant: 50).isActive = true
        sc.addTarget(self, action: #selector(segmentControlChanged), for: .valueChanged)
        return sc
    }()
    
    @objc func segmentControlChanged(sender: UISegmentedControl) {
        loginButton.setTitle(sender.titleForSegment(at: sender.selectedSegmentIndex), for: .normal)
    }
    
    lazy var login: UITextField = {
        let tf = UITextField()
        tf.placeholder = " E-mail"
        tf.heightAnchor.constraint(equalToConstant: 40).isActive = true
        tf.layer.cornerRadius = 7
        tf.layer.borderWidth = 1.5
        tf.layer.borderColor = UIColor.separator.cgColor
        tf.backgroundColor = .white
        return tf
    }()
    
    lazy var password: UITextField = {
        let tf = UITextField()
        tf.placeholder = " Пароль"
        tf.heightAnchor.constraint(equalToConstant: 40).isActive = true
        tf.layer.cornerRadius = 7
        tf.layer.borderWidth = 1.5
        tf.layer.borderColor = UIColor.separator.cgColor
        tf.backgroundColor = .white
        tf.isSecureTextEntry = true
        return tf
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton(title: reg, titleColor: .black, backgroundColor: .systemGreen, action: #selector(loginButtonPressed), target: self, targetEvent: .touchUpInside, cornerRadius: 7, tag: 0, textAlignment: .center, image: nil)
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.drawShadow()
        return button
    }()
    
    lazy var forgetButton: UIButton = {
        let button = UIButton(title: "Забыли пароль?", titleColor: .link, action: #selector(forgetButtonPressed), target: self, textAlignment: .left, image: nil)
        return button
    }()
    
    @objc func loginButtonPressed(sender: UIButton) {
        guard let viewModel = viewModel, let title = sender.currentTitle, let login = login.text, let password = password.text else { return }
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear, animations: {
            self.loginButton.transform = CGAffineTransform(translationX: -6, y: 8)
            self.loginButton.layer.shadowOpacity = 0
        }) { (true) in
            viewModel.loginButtonPressed(title: title, login: login, password: password) { [weak self] message in
                let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
                let action = UIAlertAction(title: "ok", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(action)
                self?.present(alert, animated: true, completion: nil)
            }
            self.loginButton.transform = CGAffineTransform(translationX: 0, y: 0)
            self.loginButton.layer.shadowOpacity = 0.5
        }
    }
    
    @objc func forgetButtonPressed() {
        let alert = UIAlertController(title: "Восстановление пароля", message: "Укажите адрес электронный почты с которого вы зарегистрировались. Ссылка для восстановления пароля будет отправлена на данный адрес", preferredStyle: .alert) //вызываем всплывающее окошко
        alert.addTextField { (textField) in
            textField.placeholder = "Введите e-mail"
        }
        let action = UIAlertAction(title: "Отмена", style: UIAlertAction.Style.cancel, handler: nil)
        let action2 = UIAlertAction(title: "Отправить", style: .default) { (action) in
            if let email = alert.textFields![0].text {
                if email != "" {
                    Auth.auth().sendPasswordReset(withEmail: alert.textFields![0].text!) { error in
                        if let e = error {
                            print(e.localizedDescription)
                        }
                    }
                }
            }
            
        }
        alert.addAction(action2)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func setupView() {
        title = mainTitle
        view.backgroundColor = .white
        self.navigationItem.setHidesBackButton(true, animated: true)
        view.addSubview(segmentControl)
        segmentControl.setupAnchors(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 130, left: 15, bottom: 0, right: -15))
        view.addSubview(login)
        login.setupAnchors(top: segmentControl.bottomAnchor, leading: segmentControl.leadingAnchor, bottom: nil, trailing: segmentControl.trailingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 0))
        view.addSubview(password)
        password.setupAnchors(top: login.bottomAnchor, leading: segmentControl.leadingAnchor, bottom: nil, trailing: segmentControl.trailingAnchor, padding: .init(top: 7, left: 0, bottom: 0, right: 0))
        view.addSubview(loginButton)
        loginButton.setupAnchors(top: password.bottomAnchor, leading: segmentControl.leadingAnchor, bottom: nil, trailing: segmentControl.trailingAnchor, padding: .init(top: 7, left: 0, bottom: 0, right: 0))
        view.addSubview(forgetButton)
        forgetButton.setupAnchors(top: loginButton.bottomAnchor, leading: segmentControl.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 30, left: 0, bottom: 0, right: 0))
    }
}
