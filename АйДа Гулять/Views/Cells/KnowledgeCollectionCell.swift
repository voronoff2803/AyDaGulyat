//
//  KnowledgeCollectionCell.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 22.12.2022.
//

import UIKit

class KnowledgeCollectionCell: UICollectionViewCell {
    var image: UIImage? = nil {
        didSet {
            imageView.image = image
        }
    }
    
    let counterBackgroudView = UIView().then {
        $0.backgroundColor = .appColor(.backgroundFirst)
        $0.layer.cornerRadius = 4.0
    }
    
    let counterTitleLabel = UILabel().then {
        $0.textColor = .appColor(.black)
        $0.font = .montserratRegular(size: 14)
        $0.text = "12"
    }
    
    let counterStatusIndicator = UIView().then {
        $0.backgroundColor = .appColor(.green)
        $0.layer.cornerRadius = 3.5
    }
    
    let imageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 4
    }
    
    let titleLabel = Label().then {
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.text = "Уход и содержание собаки"
        $0.font = .montserratRegular(size: 14)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
    
    private func setupUI() {        
        self.image = .appImage(.content2)
        self.layer.cornerRadius = 4
        
        let counterStatusIndicatorBG = UIView()
        counterStatusIndicatorBG.addSubview(counterStatusIndicator)
        
        let counterStackView = UIStackView(arrangedSubviews: [counterTitleLabel, counterStatusIndicatorBG]).then {
            $0.axis = .horizontal
            $0.spacing = 5.0
            
        }
        
        [imageView, titleLabel, counterBackgroudView].forEach({self.contentView.addSubview($0)})
        counterBackgroudView.addSubview(counterStackView)
        
        imageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(8.0)
            make.height.equalTo(imageView.snp.width)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(8)
        }
        counterStatusIndicatorBG.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        counterBackgroudView.snp.makeConstraints { make in
            make.height.equalTo(28)
            make.width.equalTo(42)
            make.right.bottom.equalTo(imageView).inset(10)
        }
        
        counterStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        counterStatusIndicator.snp.makeConstraints { make in
            make.height.width.equalTo(7.0)
            make.horizontalEdges.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    
    func setup() {
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.layer.opacity = 0.5
        //self.backgroundColor = .appColor(.lightGray)
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        UIView.animate(withDuration: 0.2) {
            //self.backgroundColor = .appColor(.backgroundFirst)
            self.layer.opacity = 1.0
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        UIView.animate(withDuration: 0.2) {
            //self.backgroundColor = .appColor(.backgroundFirst)
            self.layer.opacity = 1.0
        }
    }
}
