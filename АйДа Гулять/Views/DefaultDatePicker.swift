//
//  DefaultDatePicker.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 29.10.2022.
//

import UIKit

class DefaultDatePicker: UIControl {
    let textLabel = UILabel().then {
        $0.font = .montserratRegular(size: 16)
        $0.textColor = .appColor(.black)
        $0.numberOfLines = 1
        $0.textAlignment = .left
    }
    
    private let bottomBorder = UIView().then {
        $0.backgroundColor = .appColor(.lightGray)
    }
    
    let datePicker = UIDatePicker().then {
        $0.datePickerMode = .date
    }
    
    init(titleText: String) {
        textLabel.text = titleText
        
        super.init(frame: .zero)
        
        setupUI()
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
        self.backgroundColor = .appColor(.backgroundFirst)
        
        [bottomBorder, textLabel, datePicker].forEach({ self.addSubview($0) })
        
        datePicker.setValue(UIColor.appColor(.black), forKeyPath: "textColor")
        
        self.snp.makeConstraints { make in
            make.height.equalTo(55.0)
        }
        
        bottomBorder.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(1.0)
            make.horizontalEdges.equalToSuperview()
        }

        textLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.left.equalToSuperview()
            make.right.lessThanOrEqualToSuperview()
        }
        textLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        datePicker.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(textLabel.snp.right).offset(60)
            make.right.equalToSuperview()
        }
    }
}
