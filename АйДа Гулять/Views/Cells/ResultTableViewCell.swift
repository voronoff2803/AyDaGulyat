//
//  ResultTableViewCell.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 06.11.2022.
//

import UIKit

class ResultTableViewCell: UITableViewCell {
    let titleLabel = UILabel().then {
        $0.textColor = .appColor(.black)
        $0.font = .montserratRegular(size: 14)
        $0.text = "Улица Пушкина"
    }
    
    let arrowIcon = UIImageView(image: .appImage(.chevron), highlightedImage: nil)
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected {
            super.setSelected(true, animated: false)
            super.setSelected(false, animated: true)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
        
    func setupUI() {
        backgroundColor = .appColor(.backgroundFirst)
        
        separatorInset = .zero
        
        tintColor = .appColor(.black)
        
        self.hero.modifiers = [.fade, .scale(0.5)]
        
        [titleLabel, arrowIcon].forEach({self.contentView.addSubview($0)})
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(16)
        }
        
        arrowIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(16)
            make.left.greaterThanOrEqualTo(titleLabel.snp.right).offset(10)
        }
    }
}
