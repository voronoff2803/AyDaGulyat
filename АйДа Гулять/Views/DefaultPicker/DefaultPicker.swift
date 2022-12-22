//
//  DefaultPicker.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 29.10.2022.
//

import UIKit
import Combine

class DefaultPicker: UIControl {
    var subscriptions = Set<AnyCancellable>()
    var reloadble: Reloadable?
    var isManySelectable: Bool
    var values: [String] = [] {
        didSet {
            reloadble?.reload(values: values)
            
            if let index = selectedIndex, index >= 0, index < values.count {
                self.currentTextLabel.text = values[index]
            }
        }
    }
    @Published var selectedIndex: Int? = nil {
        didSet {
            if let index = selectedIndex, index >= 0, index < values.count {
                self.currentTextLabel.text = values[index]
            }
        }
    }
    
    @Published var selectedIndexes: Set<Int> = [] {
        didSet {
            if !selectedIndexes.isEmpty {
                self.currentTextLabel.text = "(\(selectedIndexes.count))"
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
    
    init(titleText: String, isManySelectable: Bool = false) {
        textLabel.text = titleText
        self.isManySelectable = isManySelectable
        
        super.init(frame: .zero)
        
        setupUI()
    }
    
    override init(frame: CGRect){
        self.isManySelectable = false
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        self.isManySelectable = false
        super.init(coder: coder)
        setupUI()
    }
    
    func setupValues(values: [String], selectedIndex: Int? = nil, selectedIndexes: Set<Int> = []) {
        self.values = values
        self.selectedIndex = selectedIndex
        self.selectedIndexes = selectedIndexes
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
        if isManySelectable {
            let selectorViewController = ListSearchViewControllerMany(items: self.values, selectedIndexes: self.selectedIndexes) { indexes in
                self.selectedIndexes = indexes
            }
            selectorViewController.title = textLabel.text
            self.reloadble = selectorViewController
            
            selectorViewController.$selectedIndexes.sink { res in
                self.selectedIndexes = res
            }
            .store(in: &subscriptions)
            
            self.parentViewController?.present(selectorViewController.embeddedInNavigation().then {
                $0.modalPresentationStyle = .overFullScreen
            }, animated: true)
        } else {
            
            let selectorViewController = ListSearchViewController(items: self.values, selectedIndex: selectedIndex) { index in
                self.selectedIndex = index
            }
            
            selectorViewController.title = textLabel.text
            self.reloadble = selectorViewController
            
            selectorViewController.$selectedIndex.sink { res in
                self.selectedIndex = res
            }
            .store(in: &subscriptions)
            
            self.parentViewController?.present(selectorViewController.embeddedInNavigation().then {
                $0.modalPresentationStyle = .overFullScreen
            }, animated: true)
            
        }
    }
}


protocol Reloadable {
    func reload(values: [String])
}
