//
//  PasswordStatusView.swift
//  PasswordResetUI
//
//  Created by Enigma Kod on 24/08/2023.
//

import SwiftUI
import UIKit

class PasswordStatusView: UIView {
    private let stackView = UIStackView()
    private let criteriaLabel = UILabel()

    private let lengthCriteriaView = PasswordCriteriaView(text: "8-32 characters (no spaces)")
    private let uppercaseCriteriaView = PasswordCriteriaView(text: "uppercase letter (A-Z)")
    private let lowerCaseCriteriaView = PasswordCriteriaView(text: "lowercase (a-z)")
    private let digitCriteriaView = PasswordCriteriaView(text: "digit (0-9)")
    private let specialCharacterCriteriaView = PasswordCriteriaView(text: "special character (e.g. !@#$%^)")

    // Used to determine if we reset criteria back to empty state (⚪️).
    var shouldResetCriteria: Bool = true

    override init(frame: CGRect) {
        super.init(frame: frame)

        style()
        layout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: 200, height: 200)
    }
}

extension PasswordStatusView {
    public func style() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .tertiarySystemFill
        layer.cornerRadius = 8
        clipsToBounds = true

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 8
        stackView.axis = .vertical
        stackView.distribution = .equalCentering
        addSubview(stackView)

        lengthCriteriaView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(lengthCriteriaView)

        criteriaLabel.translatesAutoresizingMaskIntoConstraints = false
        criteriaLabel.numberOfLines = 0
        criteriaLabel.lineBreakMode = .byWordWrapping
        criteriaLabel.attributedText = makeCriteriaMessage()
        stackView.addArrangedSubview(criteriaLabel)

        uppercaseCriteriaView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(uppercaseCriteriaView)

        lowerCaseCriteriaView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(lowerCaseCriteriaView)

        digitCriteriaView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(digitCriteriaView)

        specialCharacterCriteriaView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(specialCharacterCriteriaView)
    }

    public func layout() {
        // Stack View
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 2),
            stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2),
            trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 2),
            bottomAnchor.constraint(equalToSystemSpacingBelow: stackView.bottomAnchor, multiplier: 2),
        ])
    }

    private func makeCriteriaMessage() -> NSAttributedString {
        var plainTextAttributes = [NSAttributedString.Key: AnyObject]()
        plainTextAttributes[.font] = UIFont.preferredFont(forTextStyle: .subheadline)
        plainTextAttributes[.foregroundColor] = UIColor.secondaryLabel

        var boldTextAttributes = [NSAttributedString.Key: AnyObject]()
        boldTextAttributes[.foregroundColor] = UIColor.label
        boldTextAttributes[.font] = UIFont.preferredFont(forTextStyle: .subheadline)

        let attrText = NSMutableAttributedString(string: "Use at least ", attributes: plainTextAttributes)
        attrText.append(NSAttributedString(string: "3 of these 4 ", attributes: boldTextAttributes))
        attrText.append(NSAttributedString(string: "criteria when setting your password:", attributes: plainTextAttributes))

        return attrText
    }
}

extension PasswordStatusView {
    func updateUI(_ text: String) {
        let lengthCriteriaMet = PasswordCriteria.lengthCriteriaMet(text)
        let uppercaseMet = PasswordCriteria.uppercaseMet(text)
        let lowercaseMet = PasswordCriteria.lowercaseMet(text)
        let digitMet = PasswordCriteria.digitMet(text)
        let specialCharacterMet = PasswordCriteria.specialCharacterMet(text)

        if shouldResetCriteria {
            // Inline validation (✅ or ⚪️)
            lengthCriteriaMet ? lengthCriteriaView.isCriteriaMet = true : lengthCriteriaView.reset()
            uppercaseMet ? uppercaseCriteriaView.isCriteriaMet = true : uppercaseCriteriaView.reset()
            lowercaseMet ? lowerCaseCriteriaView.isCriteriaMet = true : lowerCaseCriteriaView.reset()
            digitMet ? digitCriteriaView.isCriteriaMet = true : digitCriteriaView.reset()
            specialCharacterMet ? specialCharacterCriteriaView.isCriteriaMet = true : specialCharacterCriteriaView.reset()
        } else {
            // Focus lost (✅ or ❌)
            lengthCriteriaView.isCriteriaMet = lengthCriteriaMet
            uppercaseCriteriaView.isCriteriaMet = uppercaseMet
            lowerCaseCriteriaView.isCriteriaMet = lowercaseMet
            digitCriteriaView.isCriteriaMet = digitMet
            specialCharacterCriteriaView.isCriteriaMet = specialCharacterMet
        }
    }

    func validate(_ text: String) -> Bool {
        // Check for 3 of 4 criteria here...
        let uppercaseMet = PasswordCriteria.uppercaseMet(text)
        let lowercaseMet = PasswordCriteria.lowercaseMet(text)
        let digitMet = PasswordCriteria.digitMet(text)
        let specialCharacterMet = PasswordCriteria.specialCharacterMet(text)

        let checkable = [uppercaseMet, lowercaseMet, digitMet, specialCharacterMet]
        let metCriteria = checkable.filter { $0 == true }

        if metCriteria.count >= 3 { return true }

        return false
    }

    func reset() {
        lengthCriteriaView.reset()
        uppercaseCriteriaView.reset()
        lowerCaseCriteriaView.reset()
        digitCriteriaView.reset()
        specialCharacterCriteriaView.reset()
    }
}

// MARK: - Preview

struct PasswordStatusViewRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        return ViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

struct PasswordStatusView_Preview: PreviewProvider {
    static var previews: some View {
        return PasswordTextFieldViewRepresentable()
    }
}
