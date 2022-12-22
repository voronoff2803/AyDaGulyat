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
    case dismiss
    case searchIcon
    case backArrow
    case chevron
    case searchButton
    case emptyProfile
    case facebookImage
    case instImage
    case vkImage
    case richArrow
    case mapPositionButton
    case checkmark
    case content3
    case tabMap
    case tabProfile
    case tabProfileSelected
    case tabMapSelected
    case searchNavBar
    case closeNavBar
    case checkCircle
}

extension UIImage {
    static func appImage(_ name: AssetsImage) -> UIImage {
        return UIImage(named: name.rawValue)!
    }
}
