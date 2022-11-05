//
//  InvisibleZoneConfigurateViewController.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 30.10.2022.
//

import UIKit
import SnapKit

class InvisibleZoneConfigurateViewController: UIViewController {
    let titleLabel = UILabel().then {
        $0.font = UIFont.montserratMedium(size: 22)
        $0.textColor = .appColor(.black)
        $0.text = "Зона невидимости"
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    let descriptionLabel = UILabel().then {
        $0.font = UIFont.montserratRegular(size: 14)
        $0.textColor = .appColor(.black)
        $0.text = "Это зона на карте, где тебя никогда не будет видно, даже в режиме прогулки. Можно установить позже в «Настройках»"
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    let segmentedControl = UISegmentedControl().then {
        $0.insertSegment(withTitle: "100 м", at: 0, animated: false)
        $0.insertSegment(withTitle: "50 м", at: 0, animated: false)
        $0.selectedSegmentIndex = 0
    }
    
    let saveButton = DefaultButton(style: .bordered).then {
        $0.setTitle("Сохранить", for: .normal)
    }
    
    let contentView = UIView().then {
        $0.backgroundColor = .appColor(.backgroundFirst)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contentView.isHidden = true
        
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.contentView.isHidden = false
        
        if self.isBeingPresented {
            self.contentView.transform = .init(translationX: 0, y: self.contentView.frame.height)
            UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseOut]) {
                self.contentView.transform = .identity
            }
        }
        
        super.viewDidAppear(false)
    }
    
    
    func setupUI() {
        self.view.backgroundColor = .clear
        
        self.view.addSubview(contentView)
        [titleLabel, descriptionLabel, segmentedControl, saveButton].forEach({ self.contentView.addSubview($0) })
        
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.montserratRegular(size: 14)], for: .normal)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.montserratMedium(size: 14)], for: .selected)
        
//        segmentedControl.addTarget(self, action: #selector(selectAction(sender:)), for: .valueChanged)
        
        contentView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.horizontalEdges.equalToSuperview().inset(28)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(28)
        }
        
        segmentedControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(descriptionLabel.snp.bottom).offset(28)
            make.width.equalTo(260)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(28)
            make.horizontalEdges.equalToSuperview().inset(28)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(28)
        }
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseIn]) {
            self.contentView.transform = .init(translationX: 0, y: self.contentView.frame.height)
        } completion: { _ in
            super.dismiss(animated: false, completion: completion)
        }
    }
}
