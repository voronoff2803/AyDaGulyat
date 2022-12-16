//
//  PersonCollectionViewCell.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 04.11.2022.
//

import UIKit

class PersonTableViewCell: UITableViewCell {
    var item: MyProfileViewModelItem? {
        didSet {
            guard let item = item as? PersonCellViewModelItem else {
                return
            }
            
            profileNameLabel.text = item.name
            //pictureImageView?.image = UIImage(named: item.pictureUrl)
        }
    }
    
    var profileImage: UIImage? = nil {
        didSet {
            imageAvatarView.image = profileImage
        }
    }
    
    let imageAvatarView = ScalableImageView().then {
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 40
        $0.hero.id = "imageView"
    }
    
    let profileNameLabel = UILabel().then {
        $0.font = .montserratSemiBold(size: 16)
        $0.numberOfLines = 1
        $0.textColor = .appColor(.black)
        $0.text = "Виктор Николаев"
    }
    
    let descriptionLabel = UILabel().then {
        $0.font = .montserratRegular(size: 14)
        $0.numberOfLines = 0
        $0.textColor = .appColor(.grayEmpty)
        $0.text = "32 года, г. Санкт-Петербург, Россия"
        $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
    
    let dividerView = UIView().then {
        $0.backgroundColor = .appColor(.lightGray)
    }
    
    let buttonsStackView = UIStackView(arrangedSubviews: [
        DefaultButton(style: .filled).then({$0.setTitle("В друзья", for: .normal)}),
        DefaultButton(style: .bordered).then({$0.setTitle("Сообщение", for: .normal)})
    ]).then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.distribution = .fillEqually
        $0.subviews.enumerated().forEach({$0.element.heroID = "button\($0.offset)"})
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
        
        selectionStyle = .none
        
        profileImage = .appImage(.content3)
        
        [imageAvatarView, profileNameLabel, descriptionLabel, buttonsStackView, dividerView].forEach({self.contentView.addSubview($0)})
        
        
        imageAvatarView.snp.makeConstraints { make in
            make.height.width.equalTo(80).priority(.high)
            make.top.equalToSuperview().inset(24)
            make.left.equalToSuperview().inset(28)
        }
        imageAvatarView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        profileNameLabel.snp.makeConstraints { make in
            make.left.equalTo(imageAvatarView.snp.right).offset(24)
            make.top.equalTo(imageAvatarView.snp.top).offset(6)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.left.equalTo(imageAvatarView.snp.right).offset(24)
            make.right.equalToSuperview().inset(28)
            make.top.equalTo(profileNameLabel.snp.bottom).offset(8)
        }

        buttonsStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(28)
            make.top.equalTo(imageAvatarView.snp.bottom).offset(24)
            make.bottom.equalToSuperview().inset(28)
        }
        
        dividerView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(28)
            make.bottom.equalToSuperview()
            make.height.equalTo(0.3)
        }
    }
}


class PersonCellViewModelItem: MyProfileViewModelItem {
    var type: MyProfileViewModel.ItemType {
        return .person
    }
    
    var rowCount: Int {
        return 1
    }
    
    var name: String
    var pictureUrl: String
    
    init(name: String, pictureUrl: String) {
        self.name = name
        self.pictureUrl = pictureUrl
    }
}
