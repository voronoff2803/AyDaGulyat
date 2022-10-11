//
//  Label.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 11.10.2022.
//

import UIKit

class Label: UILabel {
    override init(frame: CGRect){
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
    
    func setupUI() {
        self.font = UIFont.montserratRegular(size: 16)
    }
}
