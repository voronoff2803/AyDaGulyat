//
//  ViewController.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 01.10.2022.
//

import UIKit
import SnapKit
import Combine


class AuthViewController: AppRootViewController, TextFieldNextable {
    enum State {
        case normal
        case emailWorng
        case passwordWrong
        case success
    }
    
    private var subscriptions = Set<AnyCancellable>()
    var baseConstraints: [Constraint] = []
    var keyboardShowConstraints: [Constraint] = []
    let coordinator: Coordinator
    private var viewModel: AuthViewModel!
    
    let logoImageView = ScalableImageView(image: UIImage.appImage(.logo)).then {
        $0.contentMode = .scaleAspectFit
    }
    let titleLabel = Label().then {
        $0.text = "Вход"
        $0.font = .montserratRegular(size: 22)
    }
    let emailTextField = DefaultTextField().then {
        $0.placeholder = "E-mail"
        $0.textContentType = .emailAddress
        $0.autocorrectionType = .no
        $0.autocapitalizationType = .none
    }
    let passwordTextField = PasswordTextField().then {
        $0.placeholder = "Пароль"
    }
    let forgotPasswordButton = LabelButton().then {
        $0.setTitle("Забыли пароль?", for: .normal)
    }
    let loginButton = DefaultButton().then {
        $0.setTitle("Войти", for: .normal)
    }
    let authGoogle = DefaultButton(style: .bordered, leftIcon: .appImage(.googleIcon)).then {
        $0.setTitle("Продолжить с Google", for: .normal)
    }
    let noAccountLabel = Label().then {
        $0.text = "Нет аккаунта?"
    }
    let registrationButton = LabelButton().then {
        $0.setTitle("Регистрация", for: .normal)
    }
    
    override var isKeyboardHidden: Bool {
        didSet {
            baseConstraints.forEach({$0.isActive = isKeyboardHidden})
            keyboardShowConstraints.forEach({$0.isActive = !isKeyboardHidden})
            
            let scale: CGFloat = 16/22
            titleLabel.transform = isKeyboardHidden ? .identity : .init(scaleX: scale, y: scale)
        }
    }
    
    init(coordinator: Coordinator, viewModel: AuthViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        
        loginButton.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        authGoogle.addTarget(self, action: #selector(googleAction), for: .touchUpInside)
        forgotPasswordButton.addTarget(self, action: #selector(forgotPassword), for: .touchUpInside)
        registrationButton.addTarget(self, action: #selector(registerAction), for: .touchUpInside)
        passwordTextField.action = { self.loginAction() }
    }
    
    func setState(newState: AuthViewController.State) {
        switch newState {
        case .success:
            coordinator.route(to: .done, from: self, parameters: nil)
        case .normal:
            emailTextField.fieldState = .normal
            passwordTextField.fieldState = .normal
        case .emailWorng:
            emailTextField.fieldState = .error
            passwordTextField.fieldState = .normal
        case .passwordWrong:
            emailTextField.fieldState = .normal
            passwordTextField.fieldState = .error
        }
    }
    
    func setupUI() {
        self.view.backgroundColor = .appColor(.backgroundFirst)
        
        let registerButtonStack = UIStackView(arrangedSubviews: [noAccountLabel, registrationButton])
        registerButtonStack.axis = .horizontal
        registerButtonStack.spacing = 8
        
        [logoImageView, titleLabel, emailTextField, passwordTextField, forgotPasswordButton, loginButton, authGoogle, registerButtonStack].forEach({self.view.addSubview($0)})
        
        logoImageView.snp.makeConstraints { make in
            self.baseConstraints.append(make.centerX.equalToSuperview().constraint)
            self.baseConstraints.append(make.top.equalTo(self.view.safeAreaLayoutGuide).inset(30).constraint)
            self.baseConstraints.append(make.width.height.equalTo(83).constraint)
            self.keyboardShowConstraints.append(make.left.equalTo(self.view.safeAreaLayoutGuide).inset(28).priority(.low).constraint)
            self.keyboardShowConstraints.append(make.bottom.equalTo(emailTextField.snp.top).offset(-20).constraint)
            self.keyboardShowConstraints.append(make.width.height.equalTo(30).priority(.low).constraint)
        }
        
        titleLabel.snp.makeConstraints { make in
            self.baseConstraints.append(make.centerX.equalToSuperview().constraint)
            self.baseConstraints.append(make.top.equalTo(logoImageView.snp.bottom).offset(30).constraint)
            self.keyboardShowConstraints.append(make.centerY.equalTo(logoImageView).priority(.low).constraint)
            self.keyboardShowConstraints.append(make.left.equalTo(self.view.safeAreaLayoutGuide).inset(60).priority(.low).constraint)
        }
        
        self.keyboardShowConstraints.forEach({$0.isActive = false})
        
        emailTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide).inset(28)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(25)
            make.centerY.equalTo(self.view.safeAreaLayoutGuide).priority(.low)
            make.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide).inset(28)
        }
        
        forgotPasswordButton.snp.makeConstraints { make in
            make.left.equalTo(self.view.safeAreaLayoutGuide).inset(28)
            make.top.equalTo(passwordTextField.snp.bottom).offset(25)
        }
        
        loginButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide).inset(28)
            make.top.equalTo(passwordTextField.snp.bottom).offset(70)
        }
        
        keyboardAvoidView = loginButton
        
        registerButtonStack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(28)
        }
        
        authGoogle.snp.makeConstraints { make in
            make.bottom.equalTo(registerButtonStack.snp.top).offset(-21)
            make.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide).inset(28)
        }
    }
    
    func setupBindings() {
        viewModel.$authState
            .sink { value in
                self.setState(newState: value)
            }
            .store(in: &subscriptions)
        viewModel.loadingPublisher
            .sink { [weak self] isLoading in
                self?.loginButton.isLoading = isLoading
            }
            .store(in: &subscriptions)
        viewModel.errorPublisher
            .sink { [weak self] error in
                self?.showError(message: error.localizedDescription)
            }
            .store(in: &subscriptions)
        
        viewModel.$email
            .sink { value in
                self.emailTextField.text = value
            }
            .store(in: &subscriptions)
        
        viewModel.$password
            .sink { value in
                self.passwordTextField.text = value
            }
            .store(in: &subscriptions)
        emailTextField.textPublisher
            .sink(receiveValue: { value in
                self.viewModel.email = value ?? ""
            })
            .store(in: &subscriptions)
        
        passwordTextField.textPublisher
            .sink(receiveValue: { value in
                self.viewModel.password = value ?? ""
            })
            .store(in: &subscriptions)
    }
    
    @objc func loginAction() {
        viewModel.loginUser()
    }
    
    @objc func googleAction() {
        authGoogle.isLoading.toggle()
    }
    
    @objc func forgotPassword() {
        coordinator.route(to: .forgotPassword, from: self, parameters: nil)
    }
    
    @objc func registerAction() {
        coordinator.route(to: .registration, from: self, parameters: nil)
    }
}

