//
//  UIView+firstResponderGet.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 18.12.2022.
//

import UIKit


extension UIView {
    var firstResponder: UIView? {
        guard !isFirstResponder else { return self }

        for subview in subviews {
            if let firstResponder = subview.firstResponder {
                return firstResponder
            }
        }

        return nil
    }
}


extension UIView {
    var scrollView: UIScrollView? {
        if let scView = self as? UIScrollView {
            return scView
        }
        
        if let scView = superview?.scrollView {
            return scView
        }

        return nil
    }
}
