//
//  PasswordTextField.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 11.10.2022.
//

import UIKit

class PasswordTextField: DefaultTextField {
    private let rightAccessoryButton = UIButton(frame: .zero).then {
        $0.snp.makeConstraints { make in
            make.width.equalTo(42)
        }
    }
    
    var isHiddenContent: Bool = true {
        didSet {
            rightAccessoryButton.setImage(isHiddenContent ? .appImage(.closeEye) : .appImage(.openEye),
                                          for: .normal)
            self.isSecureTextEntry = isHiddenContent
        }
    }
    
    func textDidChange() {
        self.rightAccessoryButton.alpha = (text?.isEmpty ?? true) ? 0.4 : 1.0
    }
    
    override func setupUI() {
        self.textContentType = .password
        self.autocorrectionType = .no
        self.rightView = rightAccessoryButton
        self.rightViewMode = .always
        
        rightAccessoryButton.addTarget(self, action: #selector(rightButtonAction), for: .touchUpInside)
        
        isHiddenContent = {isHiddenContent}()
        
        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: self, queue: nil) { [weak self] _ in
            self?.textDidChange()
        }
        
        textDidChange()
        
        super.setupUI()
    }
    
    @objc func rightButtonAction() {
        isHiddenContent.toggle()
    }
}
