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
    var childScrollView: UIScrollView? {
        if let scView = self as? UIScrollView { return scView }

        for subview in subviews {
            if let scView = subview.childScrollView {
                return scView
            }
        }

        return nil
    }
}


extension UIView {
    var parentScrollView: UIScrollView? {
        if let scView = self as? UIScrollView {
            return scView
        }
        
        if let scView = superview?.parentScrollView {
            return scView
        }

        return nil
    }
}
