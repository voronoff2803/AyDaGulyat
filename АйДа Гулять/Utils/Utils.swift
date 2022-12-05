//
//  Utils.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 24.10.2022.
//

import Foundation
import Combine


class Utils {
    static func isValidPassword(value: String) -> Bool {
        let passwordRegex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{6,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: value)
    }
    
    static func isValidEmail(value: String) -> Bool {
        let passwordRegex = "^\\S+@\\S+\\.\\S+$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: value)
    }
}
