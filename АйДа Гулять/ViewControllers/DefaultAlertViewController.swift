//
//  DefaultAlertViewController.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 14.10.2022.
//

import UIKit

class DefaultAlertViewController: UIViewController {
    var completion: (() -> ())?
    
    init(label: String, message: String, completion: (() -> ())? = nil) {
        super.init(nibName: nil, bundle: nil)
        
        self.completion = completion
        titleLabel.text = label
        descriptionLabel.text = message
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var stackView: UIStackView = UIStackView().then {
        $0.spacing = 16
        $0.axis = .vertical
    }
    let titleLabel = UILabel().then {
        $0.text = ""
        $0.font = .montserratSemiBold(size: 22)
        $0.numberOfLines = 0
    }
    let descriptionLabel = UILabel().then {
        $0.text = ""
        $0.font = .montserratRegular(size: 14)
        $0.numberOfLines = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stackView.arrangedSubviews.forEach { view in
            if let button = view as? DefaultButton {
                button.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
            }
        }

        setupUI()
    }
    
    func setupUI() {
        [titleLabel, descriptionLabel, stackView].forEach({self.view.addSubview($0)})
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(25)
            make.horizontalEdges.equalToSuperview().inset(18)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(18)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(18)
            make.bottom.equalToSuperview().inset(25)
        }
    }
    
    @objc func dismissAction() {
        self.completion?()
        self.dismiss(animated: true)
    }
}
