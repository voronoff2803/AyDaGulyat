//
//  ProfileSmallViewController.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 02.11.2022.
//

import UIKit
import Hero

class ProfileSmallViewController: UIViewController {
    var shadowView = UIView().then {
        let shadowLayer = CAShapeLayer()
        shadowLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 110, height: 110),
                                        cornerRadius: 55).cgPath
        shadowLayer.fillColor = UIColor.clear.cgColor
        
        shadowLayer.shadowColor = UIColor.darkGray.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 10.0, height: 10.0)
        shadowLayer.shadowOpacity = 0.2
        shadowLayer.shadowRadius = 16
        
        $0.layer.insertSublayer(shadowLayer, at: 0)
    }
    
    var profileImage: UIImage? = nil {
        didSet {
            imageView.image = profileImage
        }
    }
    
    var profileNameLabel = UILabel().then {
        $0.font = .montserratSemiBold(size: 22)
        $0.numberOfLines = 1
        $0.textColor = .appColor(.black)
        $0.text = "Виктор Николаев"
    }
    
    var descriptionLabel = UILabel().then {
        $0.font = .montserratRegular(size: 16)
        $0.numberOfLines = 1
        $0.textColor = .appColor(.grayEmpty)
        $0.text = "32 года, г. Санкт-Петербург, Россия"
    }
    
    let imageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 55
    }
    
    let contentView = UIView().then {
        $0.backgroundColor = .appColor(.backgroundFirst)
        $0.clipsToBounds = false
        $0.layer.cornerRadius = 20
    }
    
    
    let buttonsStackView = UIStackView(arrangedSubviews: [
        DefaultButton(style: .filled).then({$0.setTitle("В друзья", for: .normal)}),
        DefaultButton(style: .bordered).then({$0.setTitle("Сообщение", for: .normal)})
    ]).then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.distribution = .fillEqually
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        
        contentView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan(gr:))))
        profileImage = .appImage(.emptyProfile)
    }
    
    
    func setupUI() {
        self.view.backgroundColor = .black
        
        self.view.addSubview(contentView)
        [shadowView, imageView, profileNameLabel, descriptionLabel, buttonsStackView].forEach({self.contentView.addSubview($0)})
        
        contentView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            print(self.view.safeAreaInsets.top)
            make.height.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(contentView.snp.top)
        }
        
        shadowView.snp.makeConstraints { make in
            make.center.equalTo(imageView)
            make.size.equalTo(imageView)
        }
        
        profileNameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(16)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(profileNameLabel.snp.bottom).offset(4)
        }
        
        buttonsStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(28)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(24)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(24)
        }
    }
    
    @objc func handlePan(gr: UIPanGestureRecognizer) {
        let translationY = -gr.translation(in: view).y
        switch gr.state {
        case .began:
            let vc = ProfileBigViewController()
            
            contentView.hero.id = "contentView"
            vc.view.hero.id = "contentView"
            
            imageView.hero.id = "imageView"
            //vc.imageView.hero.id = "imageView"
            
            buttonsStackView.subviews.enumerated().forEach({$0.element.heroID = "button\($0.offset)"})
            //vc.buttonsStackView.subviews.enumerated().forEach({$0.element.heroID = "button\($0.offset)"})
            
            vc.view.hero.modifiers = [.source(heroID: "heroID")]
            
            vc.modalPresentationStyle = .fullScreen
            vc.hero.modalAnimationType = .none
            vc.hero.isEnabled = true
            
            present(vc, animated: true)
        case .changed:
            Hero.shared.update(translationY / view.bounds.height)
        default:
            let velocityY = -gr.velocity(in: view).y
            if ((translationY + velocityY) / view.bounds.height) > 0.5 {
                Hero.shared.finish()
            } else {
                Hero.shared.cancel()
            }
        }
    }
}
