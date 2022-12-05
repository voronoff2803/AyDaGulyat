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
        case newPassword
        case done
        case registration
        case code
        case forgotPassword
        case back
    }
    
    enum ViewModel {
        case auth
    }
    
    var rootViewController: UIViewController!
    
    var authViewModel: AuthViewModel {
        return authViewModelCache ?? createViewModel(viewModel: .auth) as! AuthViewModel
    }
    private weak var authViewModelCache: AuthViewModel?
    
    func createViewModel(viewModel: ViewModel) -> AnyObject {
        switch viewModel {
        case .auth:
            authViewModelCache = { AuthViewModel() }()
            return authViewModelCache!
        }
    }
    
    func route(to route: Coordinator.Route, from context: UIViewController, parameters: Any?) {
        switch route {
        case .done:
            context.dismiss(animated: true)
            
            // Auth
        case .auth:
            let authViewController = AuthViewController(coordinator: self, viewModel: authViewModel).embeddedInHiddenNavigation()
            authViewController.modalPresentationStyle = .fullScreen
            context.present(authViewController, animated: true)
        case .newPassword:
            let newPasswordViewController = NewPasswordViewController(coordinator: self, viewModel: authViewModel)
            context.navigationController?.pushViewController(newPasswordViewController, animated: true)
        case .registration:
            let registrationViewController = RegistrationViewController(coordinator: self, viewModel: authViewModel)
            context.navigationController?.pushViewController(registrationViewController, animated: true)
        case .code:
            let emailCodeViewController = EmailCodeViewController(coordinator: self, viewModel: authViewModel)
            context.navigationController?.pushViewController(emailCodeViewController, animated: true)
        case .forgotPassword:
            let recoverEmailViewController = RecoverPasswordEmailViewController(coordinator: self, viewModel: authViewModel)
            context.navigationController?.pushViewController(recoverEmailViewController, animated: true)
        case .back:
            context.navigationController?.popViewController(animated: true)
        }
    }
    
    func setupRootVC() -> UIViewController {
        rootViewController = setupTabBarVC()
        return rootViewController
    }
    
    func showAuthIfNeed() {
        if !APIService.shared.isAuthenticated {
            route(to: .auth, from: rootViewController, parameters: nil)
            //route(to: .code, from: rootViewController, parameters: nil)
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
