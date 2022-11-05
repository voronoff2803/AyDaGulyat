//
//  DescriptionTableViewCell.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 05.11.2022.
//

import UIKit

class DescriptionTableViewCell: UITableViewCell {
    enum State {
        case normal
        case extended
    }
    
    var cellState: DescriptionTableViewCell.State = .normal {
        didSet {
            switch cellState {
            case .normal:
                descriptionLabel.numberOfLines = 4
            case .extended:
                descriptionLabel.numberOfLines = 0
            }
            
            self.moreLabel.isHidden = (self.cellState == .extended) ? true : false
        }
    }
    
    static let reusableID = "descriptionCell"
    
    let titleLabel = UILabel().then {
        $0.text = "О себе"
        $0.font = .montserratRegular(size: 16)
        $0.textColor = .appColor(.grayEmpty)
    }
    
    let descriptionLabel = UILabel().then {
        $0.text = "Я Виктор Николаев, живу в Питере, люблю собак. Гуляю в парках и пью кофе. Не против новых знакомств и разговоров про собак. Я Виктор Николаев, живу в Питере, люблю собак. Гуляю в парках и пью кофе. Не против новых знакомств и разговоров про собак. Я Виктор Николаев, живу в Питере, люблю собак. Гуляю в парках и пью кофе. Не против новых знакомств и разговоров про собак"
        $0.font = .montserratRegular(size: 16)
        $0.textColor = .appColor(.black)
        $0.contentMode = .top
        $0.numberOfLines = 4
    }
    
    let moreLabel = UILabel().then {
        $0.text = "Подробнее"
        $0.numberOfLines = 1
        $0.font = .montserratMedium(size: 14)
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
        
        [titleLabel, descriptionLabel, moreLabel].forEach({self.contentView.addSubview($0)})
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.horizontalEdges.equalToSuperview().inset(28)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(28)
            make.bottom.equalToSuperview().inset(30).priority(.low)
        }
        
        moreLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(28)
            make.bottom.equalToSuperview().inset(4)
        }
    }

}
