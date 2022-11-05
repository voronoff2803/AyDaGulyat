//
//  SearchFieldMapView.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 31.10.2022.
//

import UIKit

class SearchFieldMapView: UITextField {
    private let centerInset: CGPoint = CGPoint(x: 0, y: 0)
    private let descriptionText = UILabel().then {
        $0.font = UIFont.montserratRegular(size: 13)
        $0.numberOfLines = 0
        $0.textColor = .appColor(.grayEmpty)
        $0.textAlignment = .left
    }
    
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
            switch fieldState {
            case .error:
                descriptionText.textColor = .appColor(.red)
            case .success:
                descriptionText.textColor = .appColor(.grayEmpty)
            case .normal:
                self.fieldEditState = { self.fieldEditState }()
            }
        }
    }
    
    var fieldEditState: EditState = .empty {
        didSet {
            guard fieldState == .normal else { return }
            switch fieldEditState {
            case .empty:
                descriptionText.textColor = .appColor(.grayEmpty)
            case .fill:
                descriptionText.textColor = .appColor(.grayEmpty)
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
        
        self.backgroundColor = .appColor(.backgroundFirst)
        self.layer.cornerRadius = 4
        self.layer.borderColor = UIColor.appColor(.grayEmpty).cgColor
        self.layer.borderWidth = 1
        
        fieldState = {fieldState}()
        
        self.addSubview(descriptionText)
        
        if let clearButton = self.value(forKeyPath: "_clearButton") as? UIButton {
            clearButton.setImage(.appImage(.close), for: .normal)
            clearButton.tintColor = .appColor(.grayEmpty)
        }
        
        descriptionText.snp.makeConstraints { make in
            make.top.equalTo(self.snp.bottom).offset(6)
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
    
    func setLeftImage(image: UIImage) {
        let imageView = UIImageView(frame: .zero)
        imageView.image = image
        imageView.contentMode = .center
        self.leftView = imageView
        self.leftView?.transform = .init(translationX: 20, y: 0)
        self.leftView?.tintColor = .appColor(.grayEmpty)
        self.leftViewMode = .always
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 0, y: 0, width: bounds.height, height: bounds.height)
    }
    
    override var intrinsicContentSize: CGSize {
        var result = super.intrinsicContentSize
        result.height = 55
        return result
    }
    
    let padding = UIEdgeInsets(top: 0, left: 36, bottom: 0, right: 16)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
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
