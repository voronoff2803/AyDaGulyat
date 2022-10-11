//
//  LabelButton.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 11.10.2022.
//

import UIKit

class LabelButton: UIButton {
    override init(frame: CGRect){
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: isHighlighted ? 0.0 : 0.3, delay: 0.0, options: [.allowUserInteraction]) {
                self.alpha = self.isHighlighted ? 0.3 : 1.0
            }
        }
    }
    
    func setupUI() {
        self.setTitleColor(.appColor(.blue), for: .normal)
        self.titleLabel?.font = UIFont.montserratRegular(size: 16)
    }
}
