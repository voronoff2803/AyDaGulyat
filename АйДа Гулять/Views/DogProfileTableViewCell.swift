//
//  DogProfileTableViewCell.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 05.11.2022.
//

import UIKit

class DogProfileTableViewCell: UITableViewCell {
    static let reusableID = "dogProfileCell"
    
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
        
    func setupUI() {
        self.backgroundColor = .appColor(.backgroundFirst)
        
        imageAvatarView.image = .appImage(.content2)
        
        selectionStyle = .none
        
        
        [imageAvatarView, nameLabel, decriptionSmallLabel, descriptionLabel].forEach({self.contentView.addSubview($0)})
        
        imageAvatarView.snp.makeConstraints { make in
            make.height.width.equalTo(64).priority(.high)
            make.top.equalToSuperview().inset(24)
            make.left.equalToSuperview().inset(28)
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
            make.top.equalTo(imageAvatarView.snp.bottom).offset(14)
            make.horizontalEdges.equalToSuperview().inset(28)
            make.bottom.equalToSuperview().inset(16).priority(.low)
        }
    }
}
