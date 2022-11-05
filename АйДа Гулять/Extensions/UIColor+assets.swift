//
//  UIColor+asset.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 11.10.2022.
//

import UIKit


enum AssetsColor: String {
    case blue
    case black
    case grayEmpty
    case green
    case red
    case labelOnButton
    case backgroundFirst
    case lightGray
    case blueMark
}

extension UIColor {
    static func appColor(_ name: AssetsColor) -> UIColor {
        return UIColor(named: name.rawValue)!
    }
}
