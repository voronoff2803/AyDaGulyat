//
//  DogAvatarCollectionViewCell.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 22.10.2022.
//

import UIKit

class DogAvatarCollectionViewCell: UICollectionViewCell {
    var image: UIImage? = nil {
        didSet {
            imageView.image = image
        }
    }
    
    let cameraButton = UIImageView().then {
        $0.image = .appImage(.cameraButton)
    }
    
    private let imageView = UIImageView().then {
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.appColor(.grayEmpty).cgColor
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
    
    private func setupUI() {
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(cameraButton)
        
        imageView.layer.cornerRadius = 55
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        cameraButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(self.contentView.snp.bottom)
        }
    }
    
    
    func setup(model: DogAvatarModel) {
        switch model {
        case .normal(let image):
            self.isHidden = false
            self.cameraButton.isHidden = true
            self.image = image
        case .spacer:
            self.isHidden = true
            self.cameraButton.isHidden = true
        case .add:
            self.isHidden = false
            self.cameraButton.isHidden = true
            self.image = .appImage(.plusContent)
        case .empty:
            self.isHidden = false
            self.cameraButton.isHidden = false
            self.image = .appImage(.emptyContent)
        }
    }
    
    var origTransform: CGAffineTransform?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.layer.opacity = 0.5
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        UIView.animate(withDuration: 0.2) {
            self.layer.opacity = 1.0
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        UIView.animate(withDuration: 0.2) {
            self.layer.opacity = 1.0
        }
    }
}


enum DogAvatarModel {
    case normal(UIImage)
    case empty
    case spacer
    case add
}
