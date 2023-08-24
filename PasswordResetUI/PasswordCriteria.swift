//
//  PasswordCriteria.swift
//  PasswordResetUI
//
//  Created by Enigma Kod on 24/08/2023.
//

import Foundation

struct PasswordCriteria {
    static func lengthCriteriaMet(_ text: String) -> Bool {
        return noWhiteSpace(text) && text.count >= 8 && text.count <= 32
    }

    static func noWhiteSpace(_ text: String) -> Bool {
        return text.rangeOfCharacter(from: NSCharacterSet.whitespaces) == nil
    }

    static func uppercaseMet(_ text: String) -> Bool {
        return text.range(of: "[A-Z]+", options: .regularExpression) != nil
    }

    static func lowercaseMet(_ text: String) -> Bool {
        return text.range(of: "[a-z]+", options: .regularExpression) != nil
    }

    static func digitMet(_ text: String) -> Bool {
        return text.range(of: "[0-9]+", options: .regularExpression) != nil
    }

    static func specialCharacterMet(_ text: String) -> Bool {
        return text.range(of: "[@:?!()$#,./\\\\]+", options: .regularExpression) != nil
    }
}
