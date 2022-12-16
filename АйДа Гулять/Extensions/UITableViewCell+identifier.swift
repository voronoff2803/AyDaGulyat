//
//  UITableViewCell+identifier.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 16.12.2022.
//

import UIKit

extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}
