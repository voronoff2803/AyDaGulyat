//
//  DogProfileCollectionViewCell.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 06.11.2022.
//

import UIKit

class DogProfileCollectionViewCell: UICollectionViewCell {
    static let reusableID = "dogProfileCell"
    
    var delegate: DogProfileCollectionViewCellDelegate?
    
    let imageAvatarView = ScalableImageView().then {
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 32
        $0.layer.borderColor = UIColor.appColor(.blueMark).cgColor
        $0.layer.borderWidth = 3
    }
    
    
    let nameLabel = UILabel().then {
        $0.textColor = .appColor(.black)
        $0.font = .montserratSemiBold(size: 16)
        $0.text = "Рэкс"
    }
    
    let decriptionSmallLabel = UILabel().then {
        $0.text = "♂ Мальчик | 1 год"
        $0.font = .montserratRegular(size: 14)
        $0.textColor = .appColor(.black)
    }
    
    let descriptionLabel = UILabel().then {
        $0.text = "Доберман, окрас чёрный"
        $0.font = .montserratRegular(size: 14)
        $0.textColor = .appColor(.black)
        $0.contentMode = .top
        $0.numberOfLines = 0
    }
    
    let friendButton = DefaultButton(style: .filled).then {
        $0.setTitle("В друзья", for: .normal)
    }
    let profileButton = DefaultButton(style: .bordered, rightIcon: .appImage(.richArrow)).then {
        $0.setTitle("Хозяин", for: .normal)
    }
    
    lazy var buttonsStackView = UIStackView(arrangedSubviews: [friendButton, profileButton]).then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.distribution = .fillEqually
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
        
    func setupUI() {
        profileButton.addTarget(self, action: #selector(profileAction), for: .touchUpInside)
        friendButton.addTarget(self, action: #selector(friendAction), for: .touchUpInside)
        
        self.backgroundColor = .appColor(.backgroundFirst)
        
        imageAvatarView.image = .appImage(.content2)
        
        self.layer.cornerRadius = 4
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.appColor(.lightGray).cgColor
        
        
        [imageAvatarView, nameLabel, decriptionSmallLabel, descriptionLabel, buttonsStackView].forEach({self.contentView.addSubview($0)})
        
        imageAvatarView.snp.makeConstraints { make in
            make.height.width.equalTo(64).priority(.high)
            make.top.equalToSuperview().inset(20)
            make.left.equalToSuperview().inset(16)
        }
        imageAvatarView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(imageAvatarView.snp.right).offset(16)
            make.top.equalTo(imageAvatarView.snp.top).offset(8)
        }
        
        decriptionSmallLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(6)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(imageAvatarView.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(28)
        }
        
        buttonsStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    @objc func profileAction() {
        delegate?.profileAction()
    }
    
    @objc func friendAction() {
        delegate?.friendAction()
    }
}


protocol DogProfileCollectionViewCellDelegate {
    func profileAction()
    func friendAction()
}
