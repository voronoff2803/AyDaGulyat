//
//  UIView+parentVC.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 11.10.2022.
//

import UIKit


extension UIView {
    var parentViewController: UIViewController? {
        // Starts from next (As we know self is not a UIViewController).
        var parentResponder: UIResponder? = self.next
        while parentResponder != nil {
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
            parentResponder = parentResponder?.next
        }
        return nil
    }
}
