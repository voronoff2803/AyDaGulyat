//
//  ListTableViewCell.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 28.10.2022.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    let contentLabel = UILabel().then {
        $0.font = .montserratRegular(size: 16)
        $0.textColor = .appColor(.black)
        $0.numberOfLines = 1
        $0.textAlignment = .left
    }
    
    
    let checkmarkIcon = UIImageView(image: .appImage(.checkmark))
    
    var isCurrent: Bool = false {
        didSet {
            checkmarkIcon.isHidden = isCurrent ? false : true
        }
    }
    
    
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
    
    private func setupUI() {
        [contentLabel, checkmarkIcon].forEach({ contentView.addSubview($0) })
        
        self.tintColor = .appColor(.black)
        self.backgroundColor = .clear
        
        contentLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(28)
            make.centerY.equalToSuperview()
        }
        
        checkmarkIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(18)
        }
    }
}
