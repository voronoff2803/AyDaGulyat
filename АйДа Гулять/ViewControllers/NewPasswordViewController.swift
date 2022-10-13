//
//  NewPasswordViewController.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 13.10.2022.
//

import UIKit

class NewPasswordViewController: AppRootViewController, TextFieldNextable {
    let logoImageView = ScalableImageView(image: UIImage.appImage(.logo)).then {
        $0.contentMode = .scaleAspectFit
    }
    let titleLabel = Label().then {
        $0.text = "Введите новый пароль"
        $0.font = .montserratRegular(size: 22)
    }
    let passwordFirstTextField = PasswordTextField().then {
        $0.placeholder = "Пароль"
    }
    let passwordSecondTextField = PasswordTextField().then {
        $0.placeholder = "Подтверждение пароля"
        $0.descriptionTextString = "Минимум 6 символов, строчные и заглавные буквы, цифры, символы"
    }
    let loginButton = DefaultButton().then {
        $0.setTitle("Войти", for: .normal)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    func setupUI() {
        self.view.backgroundColor = .appColor(.backgroundFirst)
        
        [logoImageView, titleLabel, passwordFirstTextField, passwordSecondTextField, loginButton].forEach({self.view.addSubview($0)})
        
        logoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(30)
            make.width.height.equalTo(83)
        }
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(logoImageView.snp.bottom).offset(30)
        }
        passwordFirstTextField.snp.makeConstraints { make in
            make.centerY.equalTo(self.view.safeAreaLayoutGuide).priority(.low)
            make.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide).inset(28)
        }
        passwordSecondTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordFirstTextField.snp.bottom).offset(25)
            make.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide).inset(28)
        }
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordSecondTextField.snp.bottom).offset(70)
            make.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide).inset(28)
        }
        keyboardAvoidView = loginButton
    }

}
