//
//  ViewController.swift
//  PasswordResetUI
//
//  Created by Enigma Kod on 23/08/2023.
//

import SwiftUI
import UIKit

class ViewController: UIViewController {
    typealias CustomValidator = PasswordTextFieldView.CustomValidator

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

        setUpNewPasswordValidator()
        setupConfirmPassword()
    }

    @objc private func viewTapped() {
        view.endEditing(true)
    }

    private func style() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 20
        stackView.axis = .vertical

        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
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

    private func layout() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 2),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    private func setUpNewPasswordValidator() {
        let newPasswordValidator: CustomValidator = { text in
            guard let text = text, !text.isEmpty else {
                self.passwordStatusView.reset()
                return (false, "Enter your new password")
            }

            // Valid characters
            let validChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,@:?!()$\\/#"
            let invalidSet = CharacterSet(charactersIn: validChars).inverted
            guard text.rangeOfCharacter(from: invalidSet) == nil else {
                self.passwordStatusView.reset()
                return (false, "Enter valid special chars (.,@:?!()$\\/#) with no spaces")
            }

            self.passwordStatusView.updateUI(text)
            if !self.passwordStatusView.validate(text) {
                return (false, "Your password must meet the requirements below")
            }

            return (true, "")
        }

        passwordTextField.customValidator = newPasswordValidator
        passwordTextField.delegate = self
    }

    private func setupConfirmPassword() {
        let confirmPasswordValidation: CustomValidator = { text in
            guard let text = text, !text.isEmpty else {
                return (false, "Enter your password.")
            }

            guard text == self.passwordTextField.text else {
                return (false, "Passwords do not match.")
            }

            return (true, "")
        }

        confrimPasswordTextField.customValidator = confirmPasswordValidation
        confrimPasswordTextField.delegate = self
    }
}

extension ViewController: PasswordTextFieldDelegate {
    func editingChanged(_ sender: PasswordTextFieldView) {
        let text = sender.textField.text ?? ""

        if sender === passwordTextField {
            passwordStatusView.updateUI(text)
        }
    }

    func didEndEditing(_ sender: PasswordTextFieldView) {
        print(sender.textField.text ?? "N/A")
        if sender === passwordTextField {
            passwordStatusView.shouldResetCriteria = false
            _ = passwordTextField.validate()
        } else if sender === confrimPasswordTextField {
            _ = confrimPasswordTextField.validate()
        }
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
