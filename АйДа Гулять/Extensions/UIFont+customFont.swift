//
//  UIFont+CustomFont.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 01.10.2022.
//

import UIKit


extension UIFont {
    static func montserratRegular(size: CGFloat) -> UIFont {
        guard let customFont = UIFont(name: "Montserrat-Regular", size: size) else {
            return UIFont.systemFont(ofSize: size)
        }
        return customFont
    }
    
    static func montserratMedium(size: CGFloat) -> UIFont {
        guard let customFont = UIFont(name: "Montserrat-Medium", size: size) else {
            return UIFont.systemFont(ofSize: size)
        }
        return customFont
    }
    
    static func montserratSemiBold(size: CGFloat) -> UIFont {
        guard let customFont = UIFont(name: "Montserrat-SemiBold", size: size) else {
            return UIFont.systemFont(ofSize: size)
        }
        return customFont
    }
}

