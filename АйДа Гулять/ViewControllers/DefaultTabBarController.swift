//
//  DefaultTabBarController.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 24.12.2022.
//

import UIKit

class DefaultTabBarController: UITabBarController, UITabBarControllerDelegate {
    let coordinator: Coordinator
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.title == "dummy" {
            coordinator.route(context: self, to: .menu, parameters: nil)
            return false
        }
        return true
    }
}

