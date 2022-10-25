//
//  AgreementViewController.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 24.10.2022.
//

import UIKit

class AgreementViewController: UIViewController {
    let textView = UITextView().then {
        $0.backgroundColor = .clear
    }
    
    var exitButton = UIButton(type: .system).then {
        $0.setImage(.appImage(.close), for: .normal)
        $0.tintColor = .appColor(.grayEmpty)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        exitButton.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)

        setupUI()
    }
    
    
    func setupUI() {
        self.view.backgroundColor = .appColor(.backgroundFirst)
        
        [textView, exitButton].forEach({ self.view.addSubview($0) })
        
        exitButton.snp.makeConstraints { make in
            make.right.top.equalTo(self.view.safeAreaLayoutGuide).inset(28)
        }
        
        textView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide).inset(28)
            make.top.equalTo(exitButton.snp.bottom).offset(10)
            make.bottom.equalToSuperview()
        }
    }
    
    
    @objc func dismissAction() {
        self.dismiss(animated: true)
    }
}
