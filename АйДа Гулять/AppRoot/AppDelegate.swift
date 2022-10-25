//
//  AppDelegate.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 01.10.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    lazy var splashPresenter = SplashPresenter(window: self.window!)
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = MapViewController()
        window?.makeKeyAndVisible()
        
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

