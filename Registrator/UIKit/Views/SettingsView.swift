//
//  SettingsView.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 25.10.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import UIKit
import FirebaseAuth
import SafariServices


class SettingsView: UIView {
    
    let extraLayer = UIView()
    let nc: UINavigationController
    var disable: (() -> Void)?
    
    init(nc: UINavigationController) {
        self.nc = nc
        
        super.init(frame: .zero)
        setupView()
        nc.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    func setupView() {
        extraLayer.alpha = 0.5
        backgroundColor = .white
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemGreen.cgColor
        addSubview(termsButton)
        addSubview(privacyButton)
        termsButton.setupAnchors(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, centerX: centerXAnchor, padding: .init(top: 30, left: 0, bottom: 0, right: 0))
        privacyButton.setupAnchors(top: termsButton.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, centerX: centerXAnchor, padding: .init(top: 15, left: 0, bottom: 0, right: 0))
        setupLogoutButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        newSuperview?.addSubview(extraLayer)
        newSuperview?.endEditing(true)
        extraLayer.fillSuperview()
        extraLayer.backgroundColor = .lightGray
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        extraLayer.addGestureRecognizer(tap)
    }
    
    override func didMoveToSuperview() {
        setupAnchors(top: nil, leading: superview?.leadingAnchor, bottom: nil, trailing: superview?.trailingAnchor, centerY: superview?.centerYAnchor, padding: .init(top: 0, left: 20, bottom: 0, right: -20))
        heightAnchor.constraint(equalToConstant: 250).isActive = true
    }
    
    @objc func dismiss() {
        extraLayer.removeFromSuperview()
        removeFromSuperview()
        disable?()
    }
    
    lazy var termsButton: UIButton = {
        let button = UIButton(title: "Условия использования(Terms of Use)", titleColor: .link, action: #selector(termsButtonPressed), target: self, numberOfLines: 0, image: nil)
        return button
    }()
    
    @objc func termsButtonPressed() {
        let url = URL(string: "https://taxregistrator.wixsite.com/mysite-1")!
        let svc = SFSafariViewController(url: url)
        nc.present(svc, animated: true, completion: nil)
    }
    
    lazy var privacyButton: UIButton = {
        let button = UIButton(title: "Политика конфиденциальности (Privacy Policy)", titleColor: .link,  action: #selector(privacyButtonPressed), target: self, numberOfLines: 0, image: nil)
        return button
    }()
    
    @objc func privacyButtonPressed() {
        let url = URL(string: "https://taxregistrator.wixsite.com/mysite-1")!
        let svc = SFSafariViewController(url: url)
        nc.present(svc, animated: true, completion: nil)
    }
    
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
        do {
            try Auth.auth().signOut()
            extraLayer.removeFromSuperview()
            removeFromSuperview()
            disable?()
            LoginRouter.showModule(nc: nc)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    func setupLogoutButton() {
        let sv = UIStackView(arrangedSubviews: [logoutLabel, logoutButton])
        sv.alignment = .center
        sv.axis = .vertical
        addSubview(sv)
        sv.setupAnchors(top: privacyButton.bottomAnchor, leading: nil, bottom: nil, trailing: nil, centerX: centerXAnchor, padding: .init(top: 15, left: 0, bottom: 0, right: 0))
        
    }
}
