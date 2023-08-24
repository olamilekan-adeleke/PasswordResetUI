//
//  PasswordCriteriaView.swift
//  PasswordResetUI
//
//  Created by Enigma Kod on 24/08/2023.
//

import SwiftUI
import UIKit

class PasswordCriteriaView: UIView {
    let stackView = UIStackView()
    let iconImage = UIImageView()
    let label = UILabel()

    let checkmarkImage = UIImage(systemName: "checkmark.circle")!.withTintColor(.systemGreen, renderingMode: .alwaysOriginal)
    let xmarkImage = UIImage(systemName: "xmark.circle")!.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
    let circleImage = UIImage(systemName: "circle")!.withTintColor(.tertiaryLabel, renderingMode: .alwaysOriginal)

    var isCriteriaMet: Bool = false {
        didSet {
            if isCriteriaMet {
                iconImage.image = checkmarkImage
            } else {
                iconImage.image = xmarkImage
            }
        }
    }

    func reset() {
        isCriteriaMet = false
        iconImage.image = circleImage
    }

    init(text: String) {
        label.text = text
        super.init(frame: .zero)

        style()
        layout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: 200, height: 40)
    }
}

extension PasswordCriteriaView {
    public func style() {
        translatesAutoresizingMaskIntoConstraints = false

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        addSubview(stackView)

        iconImage.translatesAutoresizingMaskIntoConstraints = false
        iconImage.image = circleImage
        stackView.addArrangedSubview(iconImage)

        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        stackView.addArrangedSubview(label)
    }

    public func layout() {
        // CHCR
        iconImage.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
        label.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .horizontal)

        // Stack View
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])

        // Image
        NSLayoutConstraint.activate([
            iconImage.heightAnchor.constraint(equalTo: iconImage.widthAnchor),
        ])
    }
}

// MARK: - Preview

struct PasswordCriteriaViewRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        return ViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

struct PasswordCriteriaView_Preview: PreviewProvider {
    static var previews: some View {
        return PasswordTextFieldViewRepresentable()
    }
}
