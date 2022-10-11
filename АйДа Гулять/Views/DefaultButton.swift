//
//  DefaultButton.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 11.10.2022.
//

import UIKit

class DefaultButton: UIButton {
    var isLoading = false {
        didSet {
            
        }
    }
    
    var buttonStyle: Style = .filled {
        didSet {
            switch buttonStyle {
            case .filled:
                self.setTitleColor(.appColor(.labelOnButton), for: .normal)
                self.backgroundColor = .appColor(.black)
                self.layer.borderWidth = 0
            case .bordered:
                self.setTitleColor(.appColor(.black), for: .normal)
                self.backgroundColor = .appColor(.backgroundFirst)
                self.layer.borderWidth = 1
                self.layer.borderColor = UIColor.appColor(.grayEmpty).cgColor
            }
        }
    }
    
    init(style: Style, leftIcon: UIImage? = nil) {
        super.init(frame: .zero)
        self.buttonStyle = style
        if let leftIcon = leftIcon {
            self.addLeftIcon(image: leftIcon)
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
    
    func setupUI() {
        self.layer.cornerRadius = 4
        buttonStyle = {buttonStyle}()
        
        self.snp.makeConstraints { make in
            make.height.equalTo(55)
        }
        
        self.titleLabel?.font = .montserratRegular(size: 16)
    }
    
    func addLeftIcon(image: UIImage) {
        
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
    
    override var intrinsicContentSize: CGSize {
        var result = super.intrinsicContentSize
        result.height = 55
        return result
    }
    
    enum Style {
        case filled
        case bordered
    }
}


