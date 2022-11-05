//
//  ContactsTableViewCell.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 05.11.2022.
//

import UIKit

class ContactsTableViewCell: UITableViewCell {
    static let reusableID = "contactCell"
    
    let titleLabel = UILabel().then {
        $0.text = "Контакты"
        $0.font = .montserratRegular(size: 16)
        $0.textColor = .appColor(.grayEmpty)
    }
    
    let numberLabel = UILabel().then {
        $0.text = "+7 (000) 000-00-00"
        $0.font = .montserratRegular(size: 16)
        $0.textColor = .appColor(.black)
    }
    
    let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 16
    }
    
    let vkButton = UIButton(type: .system).then {
        $0.setImage(.appImage(.vkImage), for: .normal)
    }
    
    let instButton = UIButton(type: .system).then {
        $0.setImage(.appImage(.instImage), for: .normal)
    }
    
    let facebookButton = UIButton(type: .system).then {
        $0.setImage(.appImage(.facebookImage), for: .normal)
    }
    
    let dividerView = UIView().then {
        $0.backgroundColor = .appColor(.lightGray)
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
        
        [vkButton, instButton, facebookButton].forEach({stackView.addArrangedSubview($0)})
        
        [titleLabel, numberLabel, stackView, dividerView].forEach({self.contentView.addSubview($0)})
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.horizontalEdges.equalToSuperview().inset(28)
        }
        
        numberLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(14)
            make.horizontalEdges.equalToSuperview().inset(28)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(numberLabel.snp.bottom).offset(14)
            make.left.equalToSuperview().inset(28)
            make.bottom.equalToSuperview().inset(20)
        }
        
        dividerView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(28)
            make.bottom.equalToSuperview()
            make.height.equalTo(0.3)
        }
    }
}
