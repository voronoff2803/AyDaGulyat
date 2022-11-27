//
//  Coordinator.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 27.11.2022.
//

import Foundation
import UIKit


class Coordinator {
    enum Route {
        case auth
    }
    
    var rootViewController: UIViewController!
    
    func route(to route: Coordinator.Route, from context: UIViewController, parameters: Any?) {
        switch route {
        case .auth:
            let authViewController = AuthViewController(coordinator: self, viewModel: AuthViewModel())
            authViewController.modalPresentationStyle = .fullScreen
            context.present(authViewController, animated: true)
        }
    }
    
    func setupRootVC() -> UIViewController {
        rootViewController = setupTabBarVC()
        return rootViewController
    }
    
    func showAuthIfNeed() {
        if !APIService.shared.isAuthenticated {
            route(to: .auth, from: rootViewController, parameters: nil)
        }
    }
    
    private func setupTabBarVC() -> UITabBarController {
        let tabVC = UITabBarController()
        tabVC.viewControllers = setpViewControllers()
        
        tabVC.heroTabBarAnimationType = .auto
        tabVC.isHeroEnabled = true
        tabVC.tabBar.items?.forEach({$0.imageInsets = UIEdgeInsets(top: 8, left: 0, bottom: -8, right: 0)})
        
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            tabVC.tabBar.standardAppearance = appearance
            tabVC.tabBar.scrollEdgeAppearance = tabVC.tabBar.standardAppearance
        }
        
        return tabVC
    }
    
    private func setpViewControllers() -> [UIViewController] {
        let mapViewController = MapViewController()
        let profileViewController = MyProfileViewController(viewModel: MyProfileViewModel()).embeddedInNavigation()
        
        mapViewController.tabBarItem = UITabBarItem(title: nil, image: .appImage(.tabMap), selectedImage: .appImage(.tabMapSelected))
        profileViewController.tabBarItem = UITabBarItem(title: nil, image: .appImage(.tabProfile), selectedImage: .appImage(.tabProfileSelected))
        
        return [profileViewController, mapViewController]
    }
}
