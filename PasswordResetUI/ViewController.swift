//
//  ViewController.swift
//  PasswordResetUI
//
//  Created by Enigma Kod on 23/08/2023.
//

import SwiftUI
import UIKit

class ViewController: UIViewController {
    let stackView = UIStackView()
    let passwordTextField = PasswordTextFieldView(hintText: "New password")
    let passwordStatusView = PasswordStatusView()
    let confrimPasswordTextField = PasswordTextFieldView(hintText: "Re-eneter new password")
    let resetButton = UIButton(type: .system)

    override func viewDidLoad() {
        setUp()
        style()
        layout()
    }
}

extension ViewController {
    private func setUp() {
        let dissmissKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(dissmissKeyboardTap)
    }

    @objc private func viewTapped() {
        view.endEditing(true)
    }

    public func style() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 20
        stackView.axis = .vertical

        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.delegate = self
        stackView.addArrangedSubview(passwordTextField)

        passwordStatusView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(passwordStatusView)

        confrimPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(confrimPasswordTextField)

        resetButton.translatesAutoresizingMaskIntoConstraints = false
        resetButton.configuration = UIButton.Configuration.filled()
        resetButton.setTitle("Reset Password", for: [])
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        stackView.addArrangedSubview(resetButton)

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

extension ViewController: PasswordTextFieldDelegate {
    func editingChanged(_ sender: PasswordTextFieldView) {
        let text = sender.textField.text ?? ""

        if sender == passwordTextField {
            passwordStatusView.updateUI(text)
        }
    }

    func didEndEditing(_ sender: PasswordTextFieldView) {
        print(sender.textField.text ?? "N/A")
    }
}

// MARK: - Action

extension ViewController {
    @objc private func resetButtonTapped() {}
}

// MARK: - Preview

struct ViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        return ViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

struct ViewController_Preview: PreviewProvider {
    static var previews: some View {
        return PasswordTextFieldViewRepresentable()
    }
}
