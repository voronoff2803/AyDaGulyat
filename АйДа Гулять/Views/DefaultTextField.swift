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
    
    var action: (() -> ())?
    
    override var placeholder: String? {
        didSet {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: UIColor.appColor(.grayEmpty)])
        }
    }
    
    var descriptionTextString: String = "" {
        didSet {
            descriptionText.text = descriptionTextString
        }
    }
    
    var fieldState: State = .normal {
        didSet {
            if text?.isEmpty == true {
                self.fieldEditState = { self.fieldEditState }()
                return
            }
            switch fieldState {
            case .error:
                bottomBorder.backgroundColor = .appColor(.red)
                descriptionText.textColor = .appColor(.red)
            case .success:
                bottomBorder.backgroundColor = .appColor(.green)
                descriptionText.textColor = .appColor(.grayEmpty)
            case .normal:
                self.fieldEditState = { self.fieldEditState }()
            }
        }
    }
    
    override var text: String? {
        didSet {
            fieldState = { fieldState }()
        }
    }
    
    var fieldEditState: EditState = .empty {
        didSet {
            switch fieldEditState {
            case .empty:
                if fieldState == .normal {
                    bottomBorder.backgroundColor = .appColor(.lightGray)
                    descriptionText.textColor = .appColor(.grayEmpty)
                }
            case .fill:
                bottomBorder.backgroundColor = .appColor(.black)
                descriptionText.textColor = .appColor(.grayEmpty)
            }
            
            if oldValue != fieldEditState {
                fieldState = { fieldState }()
            }
        }
    }
    
    
    override func becomeFirstResponder() -> Bool {
        self.fieldEditState = .fill
        
        return super.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        self.fieldEditState = .empty
        
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
        self.clearButtonMode = .whileEditing
        self.textColor = .appColor(.black)
        
        fieldState = {fieldState}()
        
        self.addSubview(bottomBorder)
        self.addSubview(descriptionText)
        
        if let clearButton = self.value(forKeyPath: "_clearButton") as? UIButton {
            clearButton.setImage(.appImage(.close), for: .normal)
            clearButton.tintColor = .appColor(.grayEmpty)
        }
        
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
        
        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: self, queue: nil) { [weak self] _ in
            self?.textDidChange()
        }
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
            case .action:
                self.action?()
            }
            let _ = self.resignFirstResponder()
        }
    }
    
    func setLeftImage(image: UIImage) {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.image = image
        self.leftView = imageView
        self.leftView?.tintColor = .appColor(.grayEmpty)
        self.leftViewMode = .always
    }
    
    override var intrinsicContentSize: CGSize {
        var result = super.intrinsicContentSize
        result.height = 55
        return result
    }
    
    func textDidChange() {
        if text == "" {
            self.fieldState = .normal
        }
    }

//    override func textRect(forBounds bounds: CGRect) -> CGRect {
//        insetTextRect(forBounds: bounds)
//    }
//
//    override func editingRect(forBounds bounds: CGRect) -> CGRect {
//        insetTextRect(forBounds: bounds)
//    }
//
//    private func insetTextRect(forBounds bounds: CGRect) -> CGRect {
//        let insetBounds = bounds.insetBy(dx: centerInset.x, dy: centerInset.y)
//        return insetBounds
//    }
    
    enum State {
        case normal
        case error
        case success
    }
    
    enum EditState {
        case empty
        case fill
    }
}
