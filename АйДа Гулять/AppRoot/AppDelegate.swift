//
//  AppDelegate.swift
//  АйДа Гулять
///Users/alexeyvoronov/Desktop/AyDaGulyat/АйДа Гулять/Utils
//  Created by Alexey Voronov on 01.10.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    lazy var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
    
    lazy var splashPresenter = SplashPresenter(window: self.window!)
    let coordinator = Coordinator()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window?.rootViewController = coordinator.createRootVC()
        window?.makeKeyAndVisible()
        window?.overrideUserInterfaceStyle = .light
        
        coordinator.start()
        
        present()
        
        return true
    }
    
    
    func present() {
//        splashPresenter.present()
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
//            self.splashPresenter.dismiss(completion: nil)
//        }
    }
}

