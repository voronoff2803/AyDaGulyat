//
//  UIImage+asset.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 11.10.2022.
//

import UIKit


enum AssetsImage: String {
    case logoMask
    case logoLabel
    case logo
    case closeEye
    case openEye
    case googleIcon
    case close
    case content1
    case content2
    case emptyContent
    case plusContent
    case cameraButton
}

extension UIImage {
    static func appImage(_ name: AssetsImage) -> UIImage {
        return UIImage(named: name.rawValue)!
    }
}
