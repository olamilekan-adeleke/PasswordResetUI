//
//  PasswordTextFieldView.swift
//  PasswordResetUI
//
//  Created by Enigma Kod on 24/08/2023.
//

import SwiftUI
import UIKit

protocol PasswordTextFieldDelegate: AnyObject {
    func editingChanged(_ sender: PasswordTextFieldView)

    func didEndEditing(_ sender: PasswordTextFieldView)
}

class PasswordTextFieldView: UIView {
    typealias CustomValidator = (_ text: String?) -> (Bool, String)?

    let lockImageView = UIImageView(image: UIImage(systemName: "lock.fill"))
    let textField = UITextField()
    let hintText: String
    let eyeButton = UIButton(type: .custom)
    let dividerView = UIView()
    let errorLabel = UILabel()

    var customValidator: CustomValidator?
    weak var delegate: PasswordTextFieldDelegate?

    var text: String? {
        get { return textField.text }
        set { textField.text = newValue }
    }

    init(hintText: String) {
        self.hintText = hintText
        super.init(frame: .zero)

        style()
        layout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: 200, height: 60)
    }
}

extension PasswordTextFieldView {
    public func style() {
        translatesAutoresizingMaskIntoConstraints = false
        // backgroundColor = .orange

        lockImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(lockImageView)

        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isSecureTextEntry = false
        textField.placeholder = hintText
        textField.keyboardType = .asciiCapable
        textField.delegate = self
        textField.attributedPlaceholder = NSAttributedString(
            string: hintText,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel]
        )
        textField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        addSubview(textField)

        eyeButton.translatesAutoresizingMaskIntoConstraints = false
        eyeButton.setImage(UIImage(systemName: "eye.circle"), for: .normal)
        eyeButton.setImage(UIImage(systemName: "eye.slash.circle"), for: .selected)
        eyeButton.addTarget(self, action: #selector(togglePasword), for: .touchUpInside)
        addSubview(eyeButton)

        dividerView.translatesAutoresizingMaskIntoConstraints = false
        dividerView.backgroundColor = UIColor.separator
        addSubview(dividerView)

        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        errorLabel.textColor = UIColor.systemRed
        errorLabel.adjustsFontSizeToFitWidth = true
        errorLabel.minimumScaleFactor = 0.8
        errorLabel.text = "Your password must meet the requirements below."
        errorLabel.isHidden = true
        errorLabel.numberOfLines = 0
        errorLabel.lineBreakMode = .byWordWrapping
        addSubview(errorLabel)
    }

    public func layout() {
        // CHCR
        lockImageView.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
        textField.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .horizontal)
        eyeButton.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)

        // Lock Iocn
        NSLayoutConstraint.activate([
            lockImageView.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
            lockImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
        ])

        // TextField
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.leadingAnchor.constraint(equalToSystemSpacingAfter: lockImageView.trailingAnchor, multiplier: 1),
        ])

        // Eye Button
        NSLayoutConstraint.activate([
            eyeButton.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
            eyeButton.leadingAnchor.constraint(equalToSystemSpacingAfter: textField.trailingAnchor, multiplier: 1),
            eyeButton.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])

        // Divider View
        NSLayoutConstraint.activate([
            dividerView.topAnchor.constraint(equalToSystemSpacingBelow: textField.bottomAnchor, multiplier: 1),
            dividerView.heightAnchor.constraint(equalToConstant: 1),
            dividerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])

        // Error Label
        NSLayoutConstraint.activate([
            errorLabel.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 4),
            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}

extension PasswordTextFieldView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.didEndEditing(self)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("User Typed Return Key: -> \(textField.text ?? "")")
        textField.endEditing(true)
        return true
    }
}

// MARK: - Actions

extension PasswordTextFieldView {
    @objc private func togglePasword() {
        textField.isSecureTextEntry.toggle()
        eyeButton.isSelected.toggle()
    }

    @objc private func textFieldEditingChanged(_ sender: UITextField) {
        delegate?.editingChanged(self)
    }

    func validate() -> Bool {
        if let customValidator = customValidator,
           let validtionResult = customValidator(text),
           validtionResult.0 == false
        {
            showError(validtionResult.1)
            return false
        } else {
            clearError()
            return true
        }
    }

    private func showError(_ errorMessage: String) {
        errorLabel.text = errorMessage
        errorLabel.isHidden = false
    }

    private func clearError() {
        errorLabel.text = ""
        errorLabel.isHidden = true
    }
}

// MARK: - Preview

struct PasswordTextFieldViewRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        return ViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

struct PasswordTextFieldView_Preview: PreviewProvider {
    static var previews: some View {
        return PasswordTextFieldViewRepresentable()
    }
}
