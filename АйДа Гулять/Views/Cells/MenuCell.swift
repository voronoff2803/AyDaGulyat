//
//  MenuCell.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 24.12.2022.
//

import UIKit

class MenuCell: UITableViewCell {
    let titleLabel = UILabel().then {
        $0.textColor = .appColor(.black)
        $0.font = .montserratRegular(size: 16)
        $0.text = "Моя визитка"
    }
    
    let smallIcon = UIImageView(image: .appImage(.openEye), highlightedImage: nil)
    
    
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
    
    func setup(menuItem: MenuItem) {
        titleLabel.text = menuItem.title
        smallIcon.image = menuItem.icon
    }
        
    func setupUI() {
        backgroundColor = .appColor(.backgroundFirst)
        
        separatorInset = .zero
        
        tintColor = .appColor(.black)
        
        [titleLabel, smallIcon].forEach({self.contentView.addSubview($0)})
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(76)
        }
        
        smallIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(28)
        }
    }
}
