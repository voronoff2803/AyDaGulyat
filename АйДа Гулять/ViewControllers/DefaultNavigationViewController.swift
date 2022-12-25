//
//  DefaultNavigationViewController.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 28.10.2022.
//

import UIKit
import SnapKit

class DefaultNavigationViewController: UINavigationController {
    enum BarItems {
        case back
        case search
        case close
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        let appearance = UINavigationBarAppearance()
        //        appearance.configureWithOpaqueBackground()
        //        appearance.backgroundColor = UIColor.appColor(.backgroundFirst)
        //        appearance.setBackIndicatorImage(UIImage.appImage(.backArrow), transitionMaskImage: UIImage.appImage(.backArrow))
        //        appearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont.montserratSemiBold(size: 16)]
        //        navigationBar.standardAppearance = appearance
        //
        
        
        navigationBar.shadowImage = UIImage()
        navigationBar.layer.shadowColor = UIColor.black.cgColor
        navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        navigationBar.layer.shadowRadius = 10.0
        navigationBar.layer.shadowOpacity = 0.08
        navigationBar.layer.masksToBounds = false
        
        navigationBar.backIndicatorImage = .appImage(.backArrow)
        navigationBar.backIndicatorTransitionMaskImage = .appImage(.backArrow)
        navigationBar.backItem?.title = ""
        
        navigationBar.tintColor = .appColor(.black)
        
        navigationBar.prefersLargeTitles = false
        
        self.delegate = self
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //navigationBar.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.frame.width, height: height)
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if searchBarField.superview != nil {
            hideSearchBar()
        }
        
        super.pushViewController(viewController, animated: animated)

        
//        let backButton = UIBarButtonItem(image: .appImage(.backArrow), style: .done, target: nil, action: nil)
//        backButton.image = .appImage(.backArrow)
//        backButton.title = ""
//        backButton.tintColor = .appColor(.black)
//        viewController.navigationItem.backBarButtonItem = backButton
        
        viewController.navigationItem.backButtonTitle = ""
    }
    
    override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        hideSearchBar()
        return super.popToViewController(viewController, animated: animated)
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        hideSearchBar()
        return super.popViewController(animated: animated)
    }
    
    lazy var searchBarField: UITextField = SearchFieldView().then {
        $0.placeholder = "Что будем искать?"
        $0.delegate = self
        $0.autocorrectionType = .no
        $0.autocapitalizationType = .sentences
    }
    
    func showSearchBar() {
//        self.navigationBar.topItem?.titleView = searchBarField
//        searchBarField.becomeFirstResponder()
//        searchButton?.isHidden = true
        
        if searchBarField.superview == nil {
            navigationBar.layer.zPosition = 1
            
            let backGroundView = UIView()
            backGroundView.backgroundColor = .appColor(.backgroundFirst)
            backGroundView.layer.zPosition = 0
            backGroundView.addSubview(searchBarField)
            
            navigationBar.superview?.addSubview(backGroundView)
            
            backGroundView.snp.makeConstraints { make in
                make.horizontalEdges.equalToSuperview()
                make.top.equalTo(navigationBar.snp.bottom)
            }
            
            backGroundView.transform = .init(translationX: 0, y: -71)
            UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: []) {
                backGroundView.transform = .identity
                self.topViewController?.additionalSafeAreaInsets = UIEdgeInsets(top: 55 + 16, left: 0, bottom: 0, right: 0)
                self.topViewController?.view.layoutSubviews()
                self.navigationBar.layer.shadowOpacity = 0.00
            } completion: { _ in
                let _ = self.searchBarField.becomeFirstResponder()
            }
            
            searchBarField.snp.makeConstraints { make in
                make.horizontalEdges.equalToSuperview().inset(16)
                make.verticalEdges.equalToSuperview().inset(8)
            }
            
        } else {
            hideSearchBar()
        }
    }
    
    func hideSearchBar() {
        let _ = self.searchBarField.resignFirstResponder()
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: []) {
            self.topViewController?.additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            self.searchBarField.superview?.transform = .init(translationX: 0, y: -71)
            self.topViewController?.view.layoutSubviews()
            self.navigationBar.layer.shadowOpacity = 0.08
        } completion: { _ in
            self.searchBarField.superview?.removeFromSuperview()
        }
        
    }
    
    var searchButton: UIButton?
    var closeButton: UIButton?
    var backButton: UIButton?
    
    func getTabBarItem(type: BarItems) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        button.tintColor = .appColor(.black)
        
        switch type {
        case .back:
            button.setImage(UIImage.appImage(.backArrow), for: .normal)
            backButton = button
        case .search:
            button.setImage(UIImage.appImage(.searchNavBar), for: .normal)
            button.addTarget(self, action: #selector(searchButtonAction), for: .touchUpInside)
            searchButton = button
        case .close:
            button.setImage(UIImage.appImage(.closeNavBar), for: .normal)
            closeButton = button
        }
        
        
        let item = UIBarButtonItem(customView: button)
                
        item.customView?.translatesAutoresizingMaskIntoConstraints = false
        item.customView?.heightAnchor.constraint(equalToConstant: 30).isActive = true
        item.customView?.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        return item
    }
    
    @objc func searchButtonAction() {
        showSearchBar()
    }
}


extension DefaultNavigationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.hideSearchBar()
        return true
    }
}


extension DefaultNavigationViewController: UINavigationControllerDelegate {
 
    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        // 3
        return CSCardTransition.navigationController(
            navigationController,
            animationControllerFor: operation,
            from: fromVC,
            to: toVC
        )
    }
    
    func navigationController(
        _ navigationController: UINavigationController,
        interactionControllerFor animationController: UIViewControllerAnimatedTransitioning
    ) -> UIViewControllerInteractiveTransitioning? {
        // 4
        return CSCardTransition.navigationController(
            navigationController,
            interactionControllerFor: animationController
        )
    }
    
}
