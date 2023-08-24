//
//  ViewController.swift
//  PasswordResetUI
//
//  Created by Enigma Kod on 23/08/2023.
//

import UIKit

class ViewController: UIViewController {
    let passwordTextField = PasswordTextFieldView(hintText: "New Password")

    override func viewDidLoad() {
        style()
        layout()
    }
}

extension ViewController {
    public func style() {
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(passwordTextField)
    }

    public func layout() {
        NSLayoutConstraint.activate([
            passwordTextField.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: passwordTextField.leadingAnchor, multiplier: 1),
            passwordTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}
