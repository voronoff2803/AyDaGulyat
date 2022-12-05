//
//  UIViewController+embedInNavigation.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 28.10.2022.
//

import UIKit


extension UIViewController {
    func embeddedInNavigation() -> UIViewController {
        return DefaultNavigationViewController(rootViewController: self)
    }
    
    func embeddedInHiddenNavigation() -> UIViewController {
        let navigationHiddenViewController = UINavigationController(rootViewController: self)
        navigationHiddenViewController.isNavigationBarHidden = true
       
        return navigationHiddenViewController
    }
}
