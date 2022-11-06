//
//  MapButton.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 06.11.2022.
//

import UIKit

class MapButton: UIButton {

    init(rightIcon: UIImage? = nil) {
        super.init(frame: .zero)
        
        if let rightIcon = rightIcon {
            self.addRightIcon(image: rightIcon)
        }
        
        setupUI()
    }
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: isHighlighted ? 0.0 : 0.2, delay: 0.0, options: [.allowUserInteraction]) {
                self.alpha = self.isHighlighted ? 0.7 : 1.0
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
        self.tintColor = .appColor(.black)
        self.backgroundColor = .appColor(.backgroundFirst)
        
        self.layer.cornerRadius = 24
        self.layer.borderColor = UIColor.appColor(.lightGray).cgColor
        self.layer.borderWidth = 1
        
        self.setTitleColor(.appColor(.black), for: .normal)
        self.titleLabel?.font = .montserratRegular(size: 16)
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
        result.height = 48
        result.width += 80
        return result
    }
}
