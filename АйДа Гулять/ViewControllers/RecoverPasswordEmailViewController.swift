//
//  RecoverPasswordEmailViewController.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 13.10.2022.
//

import UIKit

class RecoverPasswordEmailViewController: AppRootViewController, TextFieldNextable {
    let titleLabel = Label().then {
        $0.text = "Отправим код доступа на почту"
        $0.font = .montserratRegular(size: 22)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    let emailTextField = DefaultTextField().then {
        $0.placeholder = "E-mail"
        $0.textContentType = .emailAddress
        $0.autocorrectionType = .no
        $0.autocapitalizationType = .none
    }
    
    let sendButton = DefaultButton().then {
        $0.setTitle("Отправить", for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    
    func setupUI() {
        self.view.backgroundColor = .appColor(.backgroundFirst)
        
        [titleLabel, emailTextField, sendButton].forEach({self.view.addSubview($0)})
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(50)
            make.horizontalEdges.equalToSuperview().inset(28)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.centerY.equalToSuperview().priority(.low)
            make.horizontalEdges.equalToSuperview().inset(28)
        }
        
        sendButton.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(32)
            make.horizontalEdges.equalToSuperview().inset(28)
        }
        
        keyboardAvoidView = sendButton
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
