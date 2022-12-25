//
//  KnowledgeDetailHeaderView.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 25.12.2022.
//

import UIKit

class KnowledgeDetailHeaderView: UICollectionReusableView {
    static let identifier = "KnowledgeDetailHeaderView"
    
    let titleLabel = Label().then {
        $0.text = "Уход за шерстью собаки"
        $0.font = .montserratSemiBold(size: 22)
    }
    
    let dividerView = UIView().then {
        $0.backgroundColor = .appColor(.grayEmpty)
    }
    
    let imageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 4
    }
    
    func setupUI() {
        backgroundColor = .appColor(.backgroundFirst)
        imageView.image = .appImage(.content4)
        
        [titleLabel, imageView, dividerView].forEach({self.addSubview($0)})
        
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(8)
            make.top.equalToSuperview().inset(8)
        }
        
        imageView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(8)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.height.equalTo(200)
        }
        
        dividerView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(16)
            make.height.equalTo(0.33)
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        setupUI()
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        
//        
//    }
}
