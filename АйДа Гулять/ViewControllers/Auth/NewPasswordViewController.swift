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
        case weakPassword
        case differentPassword
        case normal
    }
    
    private var subscriptions = Set<AnyCancellable>()
    private var viewModel: AuthViewModel!
    
    let logoImageView = ScalableImageView(image: UIImage.appImage(.logo)).then {
        $0.contentMode = .scaleAspectFit
    }
    
    let backButton = UIButton(type: .system).then {
        $0.setImage(.appImage(.backArrow), for: .normal)
        $0.tintColor = .appColor(.black)
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
        $0.setTitle("Продолжить", for: .normal)
    }
    
    init(viewModel: AuthViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        viewModel.newPasswordViewController = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBindings()
        
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(continueAction), for: .touchUpInside)
    }
    
    func setupBindings() {
        viewModel.$newPasswordState
            .sink { value in
                self.setState(state: value)
            }
            .store(in: &subscriptions)
        passwordFirstTextField.textPublisher
            .sink(receiveValue: { value in
                self.viewModel.password = value ?? ""
            })
            .store(in: &subscriptions)
        
        passwordSecondTextField.textPublisher
            .sink(receiveValue: { value in
                self.viewModel.newPasswordSecond = value ?? ""
            })
            .store(in: &subscriptions)
        
        viewModel.loadingPublisher
            .sink { [weak self] isLoading in
                self?.loginButton.isLoading = isLoading
            }
            .store(in: &subscriptions)
        viewModel.errorPublisher
            .sink { [weak self] error in
                self?.showError(error: error)
            }
            .store(in: &subscriptions)
    }
    
    func setState(state: NewPasswordViewController.State) {
        switch state {
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
        
        [logoImageView, titleLabel, passwordFirstTextField, passwordSecondTextField, loginButton, backButton].forEach({self.view.addSubview($0)})
        
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
    
    @objc func backAction() {
        viewModel.coordinator.route(context: self, to: .back, parameters: nil)
    }
    
    @objc func continueAction() {
        viewModel.setNewPassword()
    }
}
