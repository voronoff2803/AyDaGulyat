//
//  EmailCodeViewController.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 13.10.2022.
//

import UIKit
import Lottie

class EmailCodeViewController: AppRootViewController, TextFieldNextable {
    var state: EmailCodeViewController.State = .codeInput {
        didSet {
            switch state {
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
                activityIndicator.play()
            }
            
        }
    }
    
    
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
    
    let activityIndicator = LottieAnimationView().then {
        let animation = LottieAnimation.asset("animationActivityBlack")
        $0.loopMode = .loop
        $0.animation = animation
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        updateTime(seconds: 2)
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
        print(posfixCount)
        attributedString.addAttributes(attributes1, range: NSRange(location: 31, length: posfixCount - 31))
        
        descriptionLabel.attributedText = attributedString
    }
    
    
    func setupUI() {
        self.view.backgroundColor = .appColor(.backgroundFirst)
        self.state = {self.state}()
        
        [titleLabel, codeTextField, descriptionLabel, retryButton, activityIndicator].forEach({self.view.addSubview($0)})
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(50)
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
        
        keyboardAvoidView = codeTextField
    }

    enum State {
        case codeInput
        case requestCodeAgain
        case loading
    }

}
