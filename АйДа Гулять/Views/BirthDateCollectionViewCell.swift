//
//  BirthDateCollectionViewCell.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 04.11.2022.
//

import UIKit

class BirthDateCollectionViewCell: UITableViewCell {
    static let reusableID = "birthDateCell"
    
    let titleLabel = UILabel().then {
        $0.text = "День рождения:"
        $0.font = .montserratRegular(size: 16)
        $0.textColor = .appColor(.grayEmpty)
    }
    
    let valueLabel = UILabel().then {
        $0.text = "1 марта 1990"
        $0.font = .montserratSemiBold(size: 16)
        $0.textColor = .appColor(.black)
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
        
        [titleLabel, valueLabel].forEach({self.contentView.addSubview($0)})
        
        
        titleLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(20)
            make.left.equalToSuperview().inset(28)
        }
        
        valueLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.right).offset(16)
            make.centerY.equalToSuperview()
        }
    }
}
