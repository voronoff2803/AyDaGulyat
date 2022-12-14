//
//  SplashPresenter.swift
//  Mareshka VPN
//
//  Created by Alexey Voronov on 31.08.2022.
//

import UIKit


protocol SplashPresenterDescription {
    func present()
    func dismiss(completion: (() -> ())?)
}


class SplashPresenter: SplashPresenterDescription {
    let window: UIWindow
    //lazy var frazeString = SplashViewController.frazes.randomElement()?.localized
    
    init(window: UIWindow) {
        self.window = window
    }
    
    private lazy var animator: SplashAnimatorDescription = SplashAnimator(foregroundSplashWindow: foregroundSplashWindow, backgroundSplashWindow: backgroundSplashWindow)
    
    private lazy var foregroundSplashWindow: UIWindow = {
        let splashViewController = SplashViewController()
        splashViewController.logoIsHidden = false
        //splashViewController?.frazeString = frazeString
        
        return splashWindow(level: .normal + 1, rootViewController: splashViewController)
    }()
    
    private lazy var backgroundSplashWindow: UIWindow = {
        let splashViewController = SplashViewController()
        splashViewController.logoIsHidden = true
        //splashViewController?.frazeString = frazeString
        
        return splashWindow(level: .normal - 1, rootViewController: splashViewController)
    }()
    
    func splashWindow(level: UIWindow.Level, rootViewController: SplashViewController?) -> UIWindow {
        let splashWindow = UIWindow()
        splashWindow.windowLevel = level
        splashWindow.rootViewController = rootViewController
        
        return splashWindow
    }
    
    func present() {
        animator.animateAppearance()
    }
    
    func dismiss(completion: (() -> ())?) {
        animator.animateDisappearance(mainWindow: self.window, completion: completion)
    }
}
