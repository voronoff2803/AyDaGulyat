//
//  SelectDogCollectionViewCell.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 22.12.2022.
//

import UIKit

class SelectDogCollectionViewCell: UICollectionViewCell {
    var image: UIImage? = nil {
        didSet {
            imageView.image = image
        }
    }
    
    let imageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 4
    }
    
    let titleLabel = Label().then {
        $0.textAlignment = .center
        $0.text = "Карамелька"
        $0.font = .montserratRegular(size: 14)
    }
    
    let checkCircleImage = UIImageView(image: UIImage.appImage(.checkCircle))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
    
    private func setupUI() {
        self.image = .appImage(.content2)
        
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(checkCircleImage)
        self.contentView.addSubview(titleLabel)
        
        imageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(imageView.snp.width)
        }
        
        checkCircleImage.snp.makeConstraints { make in
            make.right.bottom.equalTo(imageView).inset(12)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(8)
        }
    }
    
    
    func setup() {
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
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
