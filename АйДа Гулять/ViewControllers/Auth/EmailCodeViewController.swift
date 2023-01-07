//
//  EmailCodeViewController.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 13.10.2022.
//

import UIKit
import Lottie
import Combine

class EmailCodeViewController: AppRootViewController, TextFieldNextable {
    enum State {
        case codeInput
        case requestCodeAgain
        case loading
    }
    
    private var subscriptions = Set<AnyCancellable>()
    private var viewModel: AuthViewModel!
    
    let titleLabel = Label().then {
        $0.text = "Введите код доступа, который пришел на почту"
        $0.font = $0.font.withSize(22)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    let descriptionLabel = Label().then {
        var fontDescriptor = UIFont.montserratRegular(size: 15).fontDescriptor
        
        fontDescriptor = fontDescriptor.addingAttributes(
            [
                UIFontDescriptor.AttributeName.featureSettings: [
                    [
                        UIFontDescriptor.FeatureKey.featureIdentifier: kNumberSpacingType,
                        UIFontDescriptor.FeatureKey.typeIdentifier: kMonospacedNumbersSelector
                    ]
                ]
            ])
        
        $0.font = UIFont(descriptor: fontDescriptor, size: 15)
        $0.textColor = .appColor(.grayEmpty)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    let codeTextField = DefaultTextField().then {
        $0.placeholder = "Код доступа"
        $0.textContentType = .oneTimeCode
        $0.autocorrectionType = .no
        $0.autocapitalizationType = .none
        $0.keyboardType = .decimalPad
    }
    
    let retryButton = LabelButton().then {
        $0.setTitle("Запросить код еще раз", for: .normal)
    }
    
    let backButton = UIButton(type: .system).then {
        $0.setImage(.appImage(.backArrow), for: .normal)
        $0.tintColor = .appColor(.black)
    }
    
    let activityIndicator = LottieAnimationView().then {
        let animation = LottieAnimation.asset("animationActivityBlack")
        $0.loopMode = .loop
        $0.animation = animation
    }
    
    init(viewModel: AuthViewModel) {
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
        
        retryButton.addTarget(self, action: #selector(requestCodeAgainAction), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
    }
    
    
    func updateTime(seconds: Int) {
        let attributedString = NSMutableAttributedString(string: "Запросить новый код\nможно через \(seconds) сек")
        
        let attributes0: [NSAttributedString.Key : Any] = [
            .foregroundColor: UIColor.appColor(.grayEmpty)
        ]
        attributedString.addAttributes(attributes0, range: NSRange(location: 0, length: 31))
        
        let attributes1: [NSAttributedString.Key : Any] = [
            .foregroundColor: UIColor.appColor(.blue)
        ]
        let posfixCount = attributedString.length
        
        attributedString.addAttributes(attributes1, range: NSRange(location: 31, length: posfixCount - 31))
        
        descriptionLabel.attributedText = attributedString
    }
    
    
    func setupUI() {
        self.view.backgroundColor = .appColor(.backgroundFirst)
        
        [titleLabel, codeTextField, descriptionLabel, retryButton, activityIndicator, backButton].forEach({self.view.addSubview($0)})
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(codeTextField.snp.top).offset(-60)
            make.horizontalEdges.equalToSuperview().inset(28)
        }
        
        codeTextField.snp.makeConstraints { make in
            make.centerY.equalToSuperview().priority(.low)
            make.horizontalEdges.equalToSuperview().inset(28)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(codeTextField.snp.bottom).offset(32)
            make.horizontalEdges.equalToSuperview().inset(28)
        }
        
        retryButton.snp.makeConstraints { make in
            make.top.equalTo(codeTextField.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.top.equalTo(codeTextField.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
        }
        
        backButton.snp.makeConstraints { make in
            make.top.left.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        keyboardAvoidView = codeTextField
    }
    
    func setupBindings() {
        viewModel.$timerSeconds
            .sink { seconds in
                self.updateTime(seconds: seconds)
            }
            .store(in: &subscriptions)
        
        viewModel.$codeState
            .sink { newState in
                self.setState(newState: newState)
            }
            .store(in: &subscriptions)
        
        viewModel.loadingPublisher
            .sink { [weak self] isLoading in
                self?.setState(newState: isLoading ? .loading : .codeInput)
            }
            .store(in: &subscriptions)
        viewModel.errorPublisher
            .sink { [weak self] error in
                self?.showError(error: error)
            }
            .store(in: &subscriptions)
        
        codeTextField.textPublisher
            .sink(receiveValue: { value in
                self.viewModel.code = value ?? ""
            })
            .store(in: &subscriptions)
        viewModel.$code
            .removeDuplicates()
            .sink { value in
                if value.count >= 6 {
                    self.viewModel.sendCode(context: self)
                }
            }
            .store(in: &subscriptions)
    }
    
    @objc func requestCodeAgainAction() {
        viewModel.sendCodeEmail(context: self, isAgain: true)
    }
    
    func setState(newState: EmailCodeViewController.State) {
        switch newState {
        case .codeInput:
            descriptionLabel.isHidden = false
            retryButton.isHidden = true
            activityIndicator.isHidden = true
            activityIndicator.stop()
        case .requestCodeAgain:
            descriptionLabel.isHidden = true
            retryButton.isHidden = false
            activityIndicator.isHidden = true
            activityIndicator.stop()
        case .loading:
            descriptionLabel.isHidden = true
            retryButton.isHidden = true
            activityIndicator.isHidden = false
            view.endEditing(true)
            activityIndicator.play()
        }
    }
    
    @objc func backAction() {
        viewModel.coordinator.route(context: self, to: .back, parameters: nil)
    }
}
