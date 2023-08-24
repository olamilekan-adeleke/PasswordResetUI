//
//  ViewController.swift
//  PasswordResetUI
//
//  Created by Enigma Kod on 23/08/2023.
//

import UIKit

class ViewController: UIViewController {
    let stackView = UIStackView()
    let passwordTextField = PasswordTextFieldView(hintText: "New Password")
    let passwordCriteriaView = PasswordCriteriaView(text: "uppercase letter (A-Z)")

    override func viewDidLoad() {
        style()
        layout()
    }
}

extension ViewController {
    public func style() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 20
        stackView.axis = .vertical

//        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(passwordCriteriaView)
        view.addSubview(stackView)
    }

    public func layout() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 2),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}
