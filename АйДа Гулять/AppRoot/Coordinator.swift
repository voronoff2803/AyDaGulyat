//
//  Coordinator.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 27.11.2022.
//

import Foundation
import UIKit
import BottomSheet
import FloatingPanel

typealias ActionCallback = (Coordinator.Route) -> ()

class Coordinator: NSObject {
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
        case userAgreement
        case selectDogs
        case knowledgeCollection
        case knowledgeDetailsCollection
        case empty
        case menu
        case walkDone
        case reader
        case createMarker
        case bigProfile
    }
    
    enum ViewModel {
        case auth
    }
    
    override init() {
        super.init()
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
    
    func route(context: UIViewController, to route: Coordinator.Route, parameters: [String: Any]?) {
        DispatchQueue.main.async { [self] in
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
                
            case .empty:
                let knowledgeCollection = KnowledgeCollectionsViewController(viewModel: KnowledgeCollectionViewModel(coordinator: self))
                let new = UIViewController()
                new.view.backgroundColor = .appColor(.backgroundFirst)
                self.present(context: context, viewController: new)
                
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
                
            case .userAgreement:
                let userAgreementViewController = AgreementViewController(coordinator: self)
                self.present(context: context, viewController: userAgreementViewController, breakNavigation: true, modalPresentationStyle: .pageSheet)
                
                
                // MyProfile
            case .profileEdit:
                let profileEditViewController = ProfileEditViewController(personEditViewModel: PersonEditViewModel(coordinator: self))
                self.present(context: context, viewController: profileEditViewController, breakNavigation: true, modalPresentationStyle: .pageSheet)
                
            case .selectDogs:
                let selectDogsViewController = SelectDogsViewController(viewModel: SelectDogsViewModel(coordinator: self))
                context.presentBottomSheet(viewController: selectDogsViewController, configuration: .default)
                
                
                //Knowledge
            case .knowledgeCollection:
                let knowledgeCollection = KnowledgeCollectionsViewController(viewModel: KnowledgeCollectionViewModel(coordinator: self))
                self.present(context: context, viewController: knowledgeCollection.embeddedInNavigation())
                
            case .knowledgeDetailsCollection:
                let knowledgeCollection = KnowledgeDetailsCollectionViewController(viewModel: KnowledgeDetailsCollectionViewModel(coordinator: self))
                self.present(context: context, viewController: knowledgeCollection)
                
            case .reader:
                let readerPageViewController = ReaderPageViewController()
                self.present(context: context, viewController: readerPageViewController)
                
            case .menu:
                let menuViewController = MenuViewController(coordinator: self)
                context.presentBottomSheet(viewController: menuViewController, configuration: .default)
                
            case .walkDone:
                let walkDoneViewController = WalkDoneViewController(viewModel: WalkViewModel(coordinator: self))
                context.presentBottomSheet(viewController: walkDoneViewController, configuration: .default)
                
            case .createMarker:
                let createMarkerPanel = CreateMarkerPanel(viewModel: CreateMarkerViewModel(coordinator: self))
                self.presentOnPanel(context: context, viewController: createMarkerPanel)
                
            case .bigProfile:
                let big = ProfileBigViewController()
                self.present(context: context, viewController: big, breakNavigation: true)
            }
        }
    }
    
    func presentOnPanel(context: UIViewController, viewController: UIViewController) {
        let fpc = FloatingPanelController()
        let contentVC = viewController
        fpc.set(contentViewController: contentVC)
        fpc.layout = TrayFloatingPanelLayout()
        
        fpc.isRemovalInteractionEnabled = true // Optional: Let it removable by a swipe-down
        
        let appearance = SurfaceAppearance()

        let shadow = SurfaceAppearance.Shadow()
        shadow.color = UIColor.black
        shadow.offset = CGSize(width: 0, height: 16)
        shadow.radius = 16
        shadow.spread = 8
        appearance.shadows = [shadow]

        appearance.cornerRadius = 10.0
        appearance.backgroundColor = .clear

        fpc.surfaceView.appearance = appearance

        context.present(fpc, animated: true, completion: nil)

        if let vc = contentVC as? ScrollViewProvider {
            if let scrollView = vc.provideScrollView {
                fpc.track(scrollView: scrollView)
            }
        }
    }
    
    func createRootVC() -> UIViewController {
        rootViewController = setupTabBarVC()
        return rootViewController
    }
    
    func start() {
        //route(context: rootViewController, to: .selectDogs, parameters: nil)
        //showAuthIfNeed()
        //showTutorial()
        
        //route(context: rootViewController, to: .createMarker, parameters: nil)
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
        let tabVC = DefaultTabBarController(coordinator: self)
        tabVC.viewControllers = setpViewControllers()
        
        //tabVC.heroTabBarAnimationType = .auto
        //tabVC.isHeroEnabled = true
        tabVC.tabBar.items?.forEach({$0.imageInsets = UIEdgeInsets(top: 8, left: 0, bottom: -8, right: 0)})
        tabVC.selectedIndex = 1
        
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
        let mapViewController = MapViewController(walkViewModel: WalkViewModel(coordinator: self))
        let profileViewController = MyProfileViewController(viewModel: MyProfileViewModel(coordinator: self)).embeddedInNavigation()
        let dummyViewController = UIViewController().then {
            $0.title = "dummy"
        }
        
        mapViewController.tabBarItem = UITabBarItem(title: nil, image: .appImage(.tabMap), selectedImage: .appImage(.tabMapSelected))
        profileViewController.tabBarItem = UITabBarItem(title: nil, image: .appImage(.tabProfile), selectedImage: .appImage(.tabProfileSelected))
        dummyViewController.tabBarItem = UITabBarItem(title: nil, image: .appImage(.tabMenu), tag: 1)
        
        return [profileViewController, mapViewController, dummyViewController]
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
