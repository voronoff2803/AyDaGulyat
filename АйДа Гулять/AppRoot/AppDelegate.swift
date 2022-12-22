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
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithDefaultBackground()
        navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont.montserratSemiBold(size: 16)]
        navigationBarAppearance.shadowColor = .clear
        navigationBarAppearance.backgroundColor = .appColor(.backgroundFirst)
        navigationBarAppearance.setBackIndicatorImage(.appImage(.backArrow), transitionMaskImage: .appImage(.backArrow))
        
        
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        
        window?.rootViewController = coordinator.createRootVC()
        window?.makeKeyAndVisible()
        window?.overrideUserInterfaceStyle = .light
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.coordinator.start()
        }
        
        
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

