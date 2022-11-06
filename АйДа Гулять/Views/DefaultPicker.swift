//
//  DefaultPicker.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 29.10.2022.
//

import UIKit

class DefaultPicker: UIControl {
    var values: [String] = []
    var selectedIndex: Int? = nil {
        didSet {
            if let index = selectedIndex, index >= 0, index < values.count {
                self.currentTextLabel.text = values[index]
            }
        }
    }
    
    let textLabel = UILabel().then {
        $0.font = .montserratRegular(size: 16)
        $0.textColor = .appColor(.black)
        $0.numberOfLines = 1
        $0.textAlignment = .left
    }
    
    let currentTextLabel = UILabel().then {
        $0.font = .montserratRegular(size: 16)
        $0.textColor = .appColor(.black)
        $0.numberOfLines = 1
        $0.textAlignment = .right
    }
    
    let chevronIconView = UIImageView().then {
        $0.image = UIImage.appImage(.chevron)
        $0.tintColor = .appColor(.black)
    }
    
    private let bottomBorder = UIView().then {
        $0.backgroundColor = .appColor(.lightGray)
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
    
    func setupValues(values: [String], selectedIndex: Int? = nil) {
        self.values = values
        self.selectedIndex = selectedIndex
    }
    
    func setupUI() {
        self.backgroundColor = .appColor(.backgroundFirst)
        
        let tapGetureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectAction))
        self.addGestureRecognizer(tapGetureRecognizer)
        
        [bottomBorder, textLabel, currentTextLabel, chevronIconView].forEach({ self.addSubview($0) })
        
        self.snp.makeConstraints { make in
            make.height.equalTo(55.0)
        }
        
        bottomBorder.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(1.0)
            make.horizontalEdges.equalToSuperview()
        }

        textLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        currentTextLabel.snp.makeConstraints { make in
            make.verticalEdges.left.equalToSuperview()
            make.right.equalToSuperview().inset(30)
        }
        
        chevronIconView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
        }
    }


    @objc func selectAction() {
        let selectorViewController  = ListSearchViewController(items: self.values, selectedIndex: selectedIndex) { index in
            self.selectedIndex = index
        }
        
        selectorViewController.title = textLabel.text
        
        self.parentViewController?.present(selectorViewController.embeddedInNavigation().then {
            $0.modalPresentationStyle = .fullScreen
        }, animated: true)
    }
}
