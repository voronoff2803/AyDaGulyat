//
//  PhotoCell.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 30.12.2022.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    var image: UIImage? = nil {
        didSet {
            imageView.image = image
        }
    }
    
    let imageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 4
    }
    
    let deleteButton = UIButton(type: .system).then {
        $0.setImage(.appImage(.deleteIcon), for: .normal)
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
        
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(deleteButton)
        
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            //make.width.equalTo(94)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.right.equalTo(contentView.snp.right)
            make.top.equalTo(contentView.snp.top)
        }
    }
    
    
    func setup() {
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.layer.opacity = 0.5
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        UIView.animate(withDuration: 0.2) {
            self.layer.opacity = 1.0
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        UIView.animate(withDuration: 0.2) {
            self.layer.opacity = 1.0
        }
    }
}
