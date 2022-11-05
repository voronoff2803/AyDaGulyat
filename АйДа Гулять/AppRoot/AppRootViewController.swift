//
//  AppRootViewController.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 11.10.2022.
//

import UIKit
import SnapKit

class AppRootViewController: UIViewController {
    var keyboardAvoidView: UIView?
    private var keyboardConstraint: Constraint?
    
    var isKeyboardHidden = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            isKeyboardHidden = false
            
            let keyboardRectangle = keyboardFrame.cgRectValue
            
            let isScrollView = keyboardAvoidView?.tag == 22
            
            let keyboardHeight = keyboardRectangle.height + (isScrollView ? 0 : 28)
            guard let keyboardAvoidView = keyboardAvoidView else { return }
            
            UIView.animate(withDuration: 0.5, delay: 0.0, options: []) {
                if self.keyboardConstraint == nil {
                    keyboardAvoidView.snp.makeConstraints { make in
                        self.keyboardConstraint = make.bottom.lessThanOrEqualToSuperview().inset(keyboardHeight).constraint.update(priority: .high)
                    }
                } else {
                    self.keyboardConstraint?.isActive = true
                }
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide() {
        isKeyboardHidden = true
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: []) {
            self.keyboardConstraint?.isActive = false
            self.view.layoutIfNeeded()
        }
    }
    
    func showAlert(buttons: [DefaultButton] = []) {
        let defaultAlertViewController = DefaultAlertViewController()
        buttons.forEach({defaultAlertViewController.stackView.addArrangedSubview($0)})
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        //alertController.setValue(defaultAlertViewController, forKey: "contentViewController")
        self.present(alertController, animated: true, completion: nil)
    }
}
