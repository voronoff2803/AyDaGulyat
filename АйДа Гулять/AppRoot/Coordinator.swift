//
//  Coordinator.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 27.11.2022.
//

import Foundation
import UIKit

typealias ActionCallback = (Coordinator.Route) -> ()

class Coordinator {
    enum Route {
        case dismiss
        case back
        case popToRoot
        case auth
        case newPassword
        case done
        case registration
        case code
        case forgotPassword
        case tutorial
        case profileEdit
    }
    
    enum ViewModel {
        case auth
    }
    
    init() {
        APIService.shared.delegate = self
    }
    
    var rootViewController: UIViewController!
    var currentViewController: UIViewController {
        get {
            currentViewControllerCache ?? rootViewController
        }
        set {
            currentViewControllerCache = newValue
        }
    }
    
    private var currentViewControllerCache: UIViewController?
    
    // Auth
    
    var isNewPasswordNeeded = false
    var authViewModel: AuthViewModel {
        return authViewModelCache ?? createViewModel(viewModel: .auth) as! AuthViewModel
    }
    private weak var authViewModelCache: AuthViewModel?
    
    func createViewModel(viewModel: ViewModel) -> AnyObject {
        switch viewModel {
        case .auth:
            authViewModelCache = { AuthViewModel(coordinator: self) }()
            return authViewModelCache!
        }
    }
    
    func present(context: UIViewController, viewController: UIViewController, breakNavigation: Bool = false, modalPresentationStyle: UIModalPresentationStyle = .fullScreen) {
        viewController.modalPresentationStyle = modalPresentationStyle
        
        if breakNavigation {
            context.present(viewController, animated: true)
        } else {
            if let nav = context.navigationController {
                nav.pushViewController(viewController, animated: true)
            } else {
                context.present(viewController, animated: true)
            }
        }
    }
    
    func route(context: UIViewController, to route: Coordinator.Route, parameters: Any?) {
        DispatchQueue.main.async {
            switch route {
            case .done:
                context.dismiss(animated: true)
            case .back:
                if let nav = context.navigationController {
                    nav.popViewController(animated: true)
                } else {
                    context.dismiss(animated: true)
                }
            case .dismiss:
                context.dismiss(animated: true)
            case .popToRoot:
                if let nav = context.navigationController {
                    nav.popToRootViewController(animated: true)
                }
                
                // Tutorial
            case .tutorial:
                let tutuorialViewController = TutorialViewController(viewModel: TutorialViewModel())
                self.present(context: context, viewController: tutuorialViewController, breakNavigation: true)
                
                // Auth
            case .auth:
                let authViewController = AuthViewController(viewModel: self.authViewModel, coordinator: self).embeddedInHiddenNavigation()
                self.present(context: context, viewController: authViewController, breakNavigation: true)
            case .newPassword:
                let newPasswordViewController = NewPasswordViewController(viewModel: self.authViewModel)
                self.present(context: context, viewController: newPasswordViewController)
            case .registration:
                self.isNewPasswordNeeded = false
                let registrationViewController = RegistrationViewController(viewModel: self.authViewModel)
                self.present(context: context, viewController: registrationViewController)
            case .code:
                let emailCodeViewController = EmailCodeViewController(viewModel: self.authViewModel)
                self.present(context: context, viewController: emailCodeViewController, breakNavigation:
                                !(context is EmailCodeViewController ||
                                  context is RegistrationViewController))
            case .forgotPassword:
                self.isNewPasswordNeeded = true
                let recoverEmailViewController = RecoverPasswordEmailViewController(viewModel: self.authViewModel)
                self.present(context: context, viewController: recoverEmailViewController)
                
                
                // MyProfile
            case .profileEdit:
                let profileEditViewController = ProfileEditViewController()
                self.present(context: context, viewController: profileEditViewController, breakNavigation: true, modalPresentationStyle: .pageSheet)
            }
        }
    }
    
    func createRootVC() -> UIViewController {
        rootViewController = setupTabBarVC()
        return rootViewController
    }
    
    func start() {
        //showAuthIfNeed()
        //showTutorial()
    }
    
    func showAuthIfNeed() {
        if !APIService.shared.isAuthenticated {
            route(context: rootViewController, to: .auth, parameters: nil)
        }
    }
    
    func showTutorial() {
        route(context: rootViewController, to: .tutorial, parameters: nil)
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
        let profileViewController = MyProfileViewController(viewModel: MyProfileViewModel(coordinator: self)).embeddedInNavigation()
        
        mapViewController.tabBarItem = UITabBarItem(title: nil, image: .appImage(.tabMap), selectedImage: .appImage(.tabMapSelected))
        profileViewController.tabBarItem = UITabBarItem(title: nil, image: .appImage(.tabProfile), selectedImage: .appImage(.tabProfileSelected))
        
        return [profileViewController, mapViewController]
    }
}


extension Coordinator: APIServiceDelegate {
    func processError(error: BaseError) -> Bool {
        switch error.message {
        //case "ErrorCodes.USER_NOT_ACTIVATED": route(to: .code, parameters: nil)
        case "ErrorCodes.JWT_REQUIRED":
            route(context: rootViewController, to: .auth, parameters: nil)
            return true
        default:
            return false
        }
    }
}
