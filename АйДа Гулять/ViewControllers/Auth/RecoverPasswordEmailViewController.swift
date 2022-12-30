//
//  RecoverPasswordEmailViewController.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 13.10.2022.
//

import UIKit
import Combine

class RecoverPasswordEmailViewController: AppRootViewController, TextFieldNextable {
    enum State {
        case normal
        case wrongEmail
    }
    
    let viewModel: AuthViewModel
    
    private var subscriptions = Set<AnyCancellable>()
    
    let titleLabel = Label().then {
        $0.text = "Отправим код доступа на почту"
        $0.font = .montserratRegular(size: 22)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    let emailTextField = DefaultTextField().then {
        $0.placeholder = "E-mail"
        $0.textContentType = .emailAddress
        $0.autocorrectionType = .no
        $0.autocapitalizationType = .none
    }
    
    let sendButton = DefaultButton().then {
        $0.setTitle("Отправить", for: .normal)
    }
    
    let backButton = UIButton(type: .system).then {
        $0.setImage(.appImage(.backArrow), for: .normal)
        $0.tintColor = .appColor(.black)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupBindings()
        
        sendButton.addTarget(self, action: #selector(sendAction), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
    }
    
    init(viewModel: AuthViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        self.view.backgroundColor = .appColor(.backgroundFirst)
        
        [titleLabel, emailTextField, sendButton, backButton].forEach({self.view.addSubview($0)})
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(emailTextField.snp.top).offset(-60)
            make.horizontalEdges.equalToSuperview().inset(28)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.centerY.equalToSuperview().priority(.low)
            make.horizontalEdges.equalToSuperview().inset(28)
        }
        
        sendButton.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(32)
            make.horizontalEdges.equalToSuperview().inset(28)
        }
        
        backButton.snp.makeConstraints { make in
            make.top.left.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        keyboardAvoidView = sendButton
    }
    
    func setState(newState: RecoverPasswordEmailViewController.State) {
        switch newState {
        case .normal:
            emailTextField.fieldState = .normal
        case .wrongEmail:
            emailTextField.fieldState = .error
        }
    }

    func setupBindings() {
        viewModel.loadingPublisher
            .sink { [weak self] isLoading in
                self?.sendButton.isLoading = isLoading
            }
            .store(in: &subscriptions)
        
        viewModel.errorPublisher
            .sink { [weak self] error in
                self?.showError(error: error)
            }
            .store(in: &subscriptions)
        
        viewModel.$recoverPasswordEmailState
            .sink { value in
                self.setState(newState: value)
            }
            .store(in: &subscriptions)
        
        viewModel.$email
            .sink { value in
                self.emailTextField.text = value
            }
            .store(in: &subscriptions)
        
        emailTextField.textPublisher
            .sink { value in
                self.viewModel.email = value ?? ""
            }
            .store(in: &subscriptions)
    }
    
    @objc func sendAction() {
        viewModel.recoverPassword(context: self)
    }
    
    @objc func backAction() {
        viewModel.coordinator.route(context: self, to: .back, parameters: nil)
    }
}
