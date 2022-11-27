//
//  DefaultButton.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 11.10.2022.
//

import UIKit
import Lottie

class DefaultButton: UIButton {
    private var animationView = LottieAnimationView().then {
        $0.isHidden = true
        $0.loopMode = .loop
        $0.isUserInteractionEnabled = false
        $0.tag = 22
    }
    
    var isLoading = false {
        didSet {
            UIView.animate(withDuration: 0.2) {
                self.subviews.filter({$0.tag != 22}).forEach({$0.alpha = self.isLoading ? 0.0 : 1.0})
            }
            animationView.isHidden = !isLoading
            if isLoading { animationView.play() } else { animationView.stop() }
        }
    }
    
    var buttonStyle: Style = .filled {
        didSet {
            switch buttonStyle {
            case .filled, .filledAlert:
                self.setTitleColor(.appColor(.labelOnButton), for: .normal)
                self.backgroundColor = .appColor(.black)
                self.layer.borderWidth = 0
            case .bordered, .borderedAlert:
                self.setTitleColor(.appColor(.black), for: .normal)
                self.backgroundColor = buttonStyle == .bordered ? .appColor(.backgroundFirst) : .clear
                self.layer.borderWidth = 1
                self.layer.borderColor = UIColor.appColor(.grayEmpty).cgColor
            }
        }
    }
    
    init(style: Style, leftIcon: UIImage? = nil, rightIcon: UIImage? = nil) {
        super.init(frame: .zero)
        self.buttonStyle = style
        if let leftIcon = leftIcon {
            self.addLeftIcon(image: leftIcon)
        }
        
        if let rightIcon = rightIcon {
            self.addRightIcon(image: rightIcon)
        }
        
        setupUI()
    }
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: isHighlighted ? 0.0 : 0.2, delay: 0.0, options: [.allowUserInteraction]) {
                self.alpha = self.isHighlighted ? 0.7 : 1.0
                self.transform = self.isHighlighted ? .init(scaleX: 0.97, y: 0.97) : .identity
            }
        }
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
    
    private func setupUI() {
        self.addSubview(animationView)
        
        self.tintColor = .appColor(.black)
        
        self.layer.cornerRadius = 4
        buttonStyle = {buttonStyle}()
        
        self.snp.makeConstraints { make in
            switch buttonStyle {
            case .filled, .bordered:
                make.height.equalTo(55)
            case .filledAlert, .borderedAlert:
                make.height.equalTo(34)
            }
        }
        
        animationView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(40)
        }
        
        switch buttonStyle {
        case .filled, .bordered:
            self.titleLabel?.font = .montserratRegular(size: 16)
        case .filledAlert, .borderedAlert:
            self.titleLabel?.font = .montserratRegular(size: 14)
        }
        
        let animation = LottieAnimation.asset(buttonStyle == .filled ? "loadAnimmationWhite" : "loadAnimmationBlack")
        animationView.animation = animation
    }
    
    private func addLeftIcon(image: UIImage) {
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.sizeToFit()
        
        addSubview(imageView)
        
        let length = CGFloat(22)
        titleEdgeInsets.left += length
        
        NSLayoutConstraint.activate([
            imageView.trailingAnchor.constraint(equalTo: self.titleLabel!.leadingAnchor, constant: -8),
            imageView.centerYAnchor.constraint(equalTo: self.titleLabel!.centerYAnchor, constant: 0),
        ])
    
    }
    
    
    private func addRightIcon(image: UIImage) {
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.sizeToFit()
        
        addSubview(imageView)
        
        let length = CGFloat(22)
        titleEdgeInsets.left -= length
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: self.titleLabel!.trailingAnchor, constant: 8),
            imageView.centerYAnchor.constraint(equalTo: self.titleLabel!.centerYAnchor, constant: 0),
        ])
    
    }
    
    override var intrinsicContentSize: CGSize {
        var result = super.intrinsicContentSize
        result.height = 55
        return result
    }
    
    enum Style {
        case filled
        case bordered
        case filledAlert
        case borderedAlert
    }
}


