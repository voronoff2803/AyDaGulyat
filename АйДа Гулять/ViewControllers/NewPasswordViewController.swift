//
//  NewPasswordViewController.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 13.10.2022.
//

import UIKit
import Combine
import CombineCocoa

class NewPasswordViewController: AppRootViewController, TextFieldNextable {
    enum State {
        case empty
        case weakPassword
        case differentPassword
        case normal
    }
    
    private var subscriptions = Set<AnyCancellable>()
    private var viewModel: AuthViewModel!
    
    let logoImageView = ScalableImageView(image: UIImage.appImage(.logo)).then {
        $0.contentMode = .scaleAspectFit
    }
    let titleLabel = Label().then {
        $0.text = "Введите новый пароль"
        $0.font = .montserratRegular(size: 22)
    }
    let passwordFirstTextField = PasswordTextField().then {
        $0.placeholder = "Пароль"
        $0.descriptionTextString = "Минимум 6 символов, строчные и заглавные буквы, цифры, символы"
    }
    let passwordSecondTextField = PasswordTextField().then {
        $0.placeholder = "Подтверждение пароля"
    }
    let loginButton = DefaultButton().then {
        $0.setTitle("Войти", for: .normal)
    }
    
    init(viewModel: AuthViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        
        viewModel.loginUser(email: "test", password: "test")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBindings()
    }
    
    func setupBindings() {
        passwordFirstTextField.textPublisher
            .sink(receiveValue: { value in
                self.viewModel.newPasswordFirst = value ?? ""
            })
            .store(in: &subscriptions)
        
        passwordSecondTextField.textPublisher
            .sink(receiveValue: { value in
                self.viewModel.newPasswordSecond = value ?? ""
            })
            .store(in: &subscriptions)
        
        viewModel.$newPasswordState
            .sink { value in
                self.setState(state: value)
            }
            .store(in: &subscriptions)
    }
    
    func setState(state: NewPasswordViewController.State) {
        switch state {
        case .empty:
            passwordFirstTextField.fieldState = .normal
            passwordSecondTextField.fieldState = .normal
        case .weakPassword:
            passwordFirstTextField.fieldState = .error
            passwordSecondTextField.fieldState = .normal
        case .differentPassword:
            passwordFirstTextField.fieldState = .normal
            passwordSecondTextField.fieldState = .error
        case .normal:
            passwordFirstTextField.fieldState = .success
            passwordSecondTextField.fieldState = .success
        }
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
            make.top.equalTo(passwordFirstTextField.snp.bottom).offset(45)
            make.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide).inset(28)
        }
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordSecondTextField.snp.bottom).offset(70)
            make.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide).inset(28)
        }
        keyboardAvoidView = loginButton
    }
}
