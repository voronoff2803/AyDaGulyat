//
//  DefaultSegmentedPicker.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 29.10.2022.
//

import UIKit

class DefaultSegmentedPicker: UIControl {
    var values: [String] = []
    var selectedIndex: Int? = nil {
        didSet {
            if let index = selectedIndex {
                segmentedControl.selectedSegmentIndex = index
            } else {
                segmentedControl.selectedSegmentIndex = -1
            }
        }
    }
    
    let textLabel = UILabel().then {
        $0.font = .montserratRegular(size: 16)
        $0.textColor = .appColor(.black)
        $0.numberOfLines = 1
        $0.textAlignment = .left
    }
    
    private let bottomBorder = UIView().then {
        $0.backgroundColor = .appColor(.lightGray)
    }
    
    let segmentedControl = UISegmentedControl().then {
        $0.backgroundColor = UIColor.clear.withAlphaComponent(0.0)
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
        
        self.values.forEach({ self.segmentedControl.insertSegment(withTitle: $0, at: 0, animated: false) })
    }
    
    func setupUI() {
        self.backgroundColor = .appColor(.backgroundFirst)
        
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.montserratRegular(size: 16)], for: .normal)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.montserratMedium(size: 16)], for: .selected)
        
        segmentedControl.addTarget(self, action: #selector(selectAction(sender:)), for: .valueChanged)
        
        [bottomBorder, textLabel, segmentedControl].forEach({ self.addSubview($0) })
        
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
        
        segmentedControl.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(textLabel.snp.right).offset(60)
            make.right.equalToSuperview()
        }
    }


    @objc func selectAction(sender: UISegmentedControl?) {
        self.selectedIndex = sender?.selectedSegmentIndex
    }
}
