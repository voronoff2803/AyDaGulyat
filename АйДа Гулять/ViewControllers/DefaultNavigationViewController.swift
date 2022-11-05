//
//  DefaultNavigationViewController.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 28.10.2022.
//

import UIKit

class DefaultNavigationViewController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        let appearance = UINavigationBarAppearance()
        //        appearance.configureWithOpaqueBackground()
        //        appearance.backgroundColor = UIColor.appColor(.backgroundFirst)
        //        appearance.setBackIndicatorImage(UIImage.appImage(.backArrow), transitionMaskImage: UIImage.appImage(.backArrow))
        //        appearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont.montserratSemiBold(size: 16)]
        //        navigationBar.standardAppearance = appearance
        //
        
        
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithDefaultBackground()
        navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont.montserratSemiBold(size: 16)]
        navigationBarAppearance.shadowColor = .clear
        
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        
        navigationBar.shadowImage = UIImage()
        navigationBar.layer.shadowColor = UIColor.black.cgColor
        navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        navigationBar.layer.shadowRadius = 10.0
        navigationBar.layer.shadowOpacity = 0.08
        navigationBar.layer.masksToBounds = false
        
        navigationBar.backIndicatorImage = .appImage(.backArrow)
        navigationBar.backIndicatorTransitionMaskImage = .appImage(.backArrow)
        navigationBar.backItem?.title = ""
        
        navigationBar.prefersLargeTitles = false
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationBar.topItem?.backBarButtonItem = backButton
    }
}
