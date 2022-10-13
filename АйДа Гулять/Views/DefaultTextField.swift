//
//  DefaultTextField.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 11.10.2022.
//

import UIKit
import SnapKit

class DefaultTextField: UITextField {
    private let centerInset: CGPoint = CGPoint(x: 0, y: 0)
    private let bottomBorder = UIView()
    private let descriptionText = UILabel().then {
        $0.font = UIFont.montserratRegular(size: 13)
        $0.numberOfLines = 0
        $0.textColor = .appColor(.grayEmpty)
        $0.textAlignment = .left
    }
    
    var descriptionTextString: String = "" {
        didSet {
            descriptionText.text = descriptionTextString
        }
    }
    
    var fieldState: State = .empty {
        didSet {
            switch fieldState {
            case .empty:
                bottomBorder.backgroundColor = .appColor(.grayEmpty)
                descriptionText.textColor = .appColor(.grayEmpty)
            case .fill:
                bottomBorder.backgroundColor = .appColor(.black)
                descriptionText.textColor = .appColor(.grayEmpty)
            case .error:
                bottomBorder.backgroundColor = .appColor(.red)
                descriptionText.textColor = .appColor(.red)
            case .success:
                bottomBorder.backgroundColor = .appColor(.green)
                descriptionText.textColor = .appColor(.grayEmpty)
            }
        }
    }
    
    override func becomeFirstResponder() -> Bool {
        self.fieldState = .fill
        
        return super.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        self.fieldState = .empty
        
        return super.resignFirstResponder()
    }

    // MARK: - UITextField
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
    
    func setupUI() {
        self.font = .montserratRegular(size: 16)
        self.tintColor = .black
        
        fieldState = {fieldState}()
        
        self.addSubview(bottomBorder)
        self.addSubview(descriptionText)
        
        bottomBorder.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(1.0)
            make.horizontalEdges.equalToSuperview()
        }
        
        descriptionText.snp.makeConstraints { make in
            make.top.equalTo(bottomBorder.snp.bottom).offset(6)
            make.horizontalEdges.equalToSuperview()
        }
        
        self.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(55)
        }
        
        self.addTarget(self, action: #selector(returnKeyAction), for: .primaryActionTriggered)
    }
    
    @objc func returnKeyAction() {
        tryToGoNextTextField()
    }
    
    func tryToGoNextTextField() {
        if let nextableVC = self.superview?.parentViewController as? TextFieldNextable {
            let textFieldOrAction = nextableVC.nextFieldOrActoin(for: self)
            switch textFieldOrAction {
            case .nextTextField(let textField):
                textField.becomeFirstResponder()
            case .action(let action):
                action?()
            }
            let _ = self.resignFirstResponder()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        var result = super.intrinsicContentSize
        result.height = 55
        return result
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        insetTextRect(forBounds: bounds)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        insetTextRect(forBounds: bounds)
    }

    private func insetTextRect(forBounds bounds: CGRect) -> CGRect {
        let insetBounds = bounds.insetBy(dx: centerInset.x, dy: centerInset.y)
        return insetBounds
    }
    
    enum State {
        case empty
        case fill
        case error
        case success
    }
}
