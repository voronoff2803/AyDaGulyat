//
//  RegistrationViewController.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 13.10.2022.
//

import UIKit
import SnapKit
import Then
import ActiveLabel
import Combine


class RegistrationViewController: AppRootViewController, TextFieldNextable {
    enum State {
        case empty
        case success
        case normal(Bool, Bool)
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
        $0.text = "Регистрация"
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
        $0.descriptionTextString = "Минимум 6 символов, строчные и заглавные буквы, цифры, символы"
    }
    let registrationButton = DefaultButton().then {
        $0.setTitle("Зарегистрироваться", for: .normal)
    }

    let noAccountLabel = Label().then {
        $0.text = "Есть аккаунт?"
    }
    let loginButton = LabelButton().then {
        $0.setTitle("Войти", for: .normal)
    }
    let descriptionLabel = ActiveLabel().then {
        let attributedString = NSMutableAttributedString(string: "Нажимая кнопку, я соглашаюсь с пользовательским соглашением и даю согласие на обработку персональных данных")

        let customType = ActiveType.custom(pattern: "\\sпользовательским соглашением\\b")
        
        $0.enabledTypes = [customType]
        $0.attributedText = attributedString
        $0.customColor[customType] = .appColor(.blue)
        $0.customSelectedColor[customType] = .appColor(.blue).withAlphaComponent(0.5)
        $0.font = .montserratRegular(size: 15)
        $0.textColor = .appColor(.grayEmpty)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.isUserInteractionEnabled = true
        $0.backgroundColor = .clear
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
    
    func setState(newState: RegistrationViewController.State) {
        switch newState {
        case .success:
            coordinator.route(to: .code, from: self, parameters: nil)
        case .normal(let validEmail, let validPassword):
            emailTextField.fieldState = validEmail ? .success : .error
            passwordTextField.fieldState = validPassword ? .success : .error
        case .empty:
            emailTextField.fieldState = .normal
            passwordTextField.fieldState = .normal
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        
        registrationButton.addTarget(self, action: #selector(registrationAction), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(authAction), for: .touchUpInside)
        
        descriptionLabel.handleCustomTap(for: descriptionLabel.enabledTypes.first!) { _ in
            print("show license")
        }
        
        passwordTextField.action = { self.viewModel.registrationUser() }
    }
    
    func setupUI() {
        self.view.backgroundColor = .appColor(.backgroundFirst)
        
        let registerButtonStack = UIStackView(arrangedSubviews: [noAccountLabel, loginButton])
        registerButtonStack.axis = .horizontal
        registerButtonStack.spacing = 8
        
        [logoImageView, titleLabel, emailTextField, passwordTextField, registrationButton, registerButtonStack, descriptionLabel].forEach({self.view.addSubview($0)})
        
//        descriptionLabel.delegate = self
        
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
        
        registrationButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide).inset(28)
            make.top.equalTo(passwordTextField.snp.bottom).offset(70)
        }
        
        keyboardAvoidView = registrationButton
        
        registerButtonStack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(28)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(registrationButton.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.width.equalTo(290)
            make.height.equalTo(90)
        }
    }
    
    func setupBindings() {
        viewModel.$registrationState
            .sink { value in
                self.setState(newState: value)
            }
            .store(in: &subscriptions)
        viewModel.loadingPublisher
            .sink { [weak self] isLoading in
                self?.registrationButton.isLoading = isLoading
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
    
    @objc func registrationAction() {
        viewModel.registrationUser()
    }
    
    @objc func authAction() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}


extension RegistrationViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        print(URL.absoluteString)
        return false
    }
}
