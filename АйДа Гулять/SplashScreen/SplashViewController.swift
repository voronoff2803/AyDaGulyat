//
//  SplashViewController.swift
//  Mareshka VPN
//
//  Created by Alexey Voronov on 31.08.2022.
//

import UIKit
import Lottie


class SplashViewController: UIViewController {
    
    static let logoMask = UIImage.appImage(.logoMask)
    
    let logoImageView = UIImageView(image: UIImage.appImage(.logo))
    let logoLabelImageView = UIImageView(image: UIImage.appImage(.logoLabel))
    let animationView = LottieAnimationView()
    
    var frazeString: String?
    
//    static let frazes = [
//        "splash1",
//        "splash2",
//        "splash3",
//        "splash4",
//        "splash5",
//        "splash6",
//        "splash7",
//        "splash8",
//        "splash9",
//        "splash10",
//        "splash11",
//        "splash12",
//        "splash13"
//        ]
    
    var logoIsHidden = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoImageView.isHidden = logoIsHidden
        self.view.backgroundColor = .systemBackground
        
        
        setupUI()
        animate()
    }
    
    func animate() {
        logoLabelImageView.alpha = 0.0
        logoLabelImageView.transform = .init(translationX: 0, y: 20)
        
        UIView.animate(withDuration: 0.3) {
            self.logoLabelImageView.alpha = 1.0
            self.logoLabelImageView.transform = .identity
        }
    }
    
    func setupUI() {
        let animation = LottieAnimation.asset("splashAnimationBlack")
        animationView.animation = animation
        if logoIsHidden {
            animationView.currentProgress = 1.0
        } else {
            animationView.play()
        }
        
        [logoImageView, animationView, logoLabelImageView].forEach({self.view.addSubview($0)})
        
        logoImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-30)
            make.centerX.equalToSuperview()
        }
        
        animationView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().inset(60.0)
        }
        
        logoLabelImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(logoImageView.snp.bottom).offset(17)
        }
    }
}
