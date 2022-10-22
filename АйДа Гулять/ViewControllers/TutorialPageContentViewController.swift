//
//  TutorialPageContentViewController.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 19.10.2022.
//

import UIKit

class TutorialPageContentViewController: UIViewController {
    var tutorialContentModel: TutorialContentModel? = nil
    var index = 0
    
    let contentImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    let contentLabel = UILabel().then {
        $0.font = .montserratRegular(size: 15)
        $0.textColor = .appColor(.black)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup(tutorialContentModel: tutorialContentModel)
        setupUI()
    }
    
    func setup(tutorialContentModel: TutorialContentModel?) {
        contentLabel.attributedText = NSAttributedString.fromMarkdown(source: tutorialContentModel?.labelText ?? "")
        contentImageView.image = UIImage(named: tutorialContentModel?.imageName ?? "")
    }
    
    func setupUI() {
        self.view.backgroundColor = .appColor(.backgroundFirst)
        
        [contentImageView, contentLabel].forEach({self.view.addSubview($0)})
        
        
        
        contentImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide).inset(60)
        }
        
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(contentImageView.snp.bottom).offset(40)
            make.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide).inset(28)
            make.height.greaterThanOrEqualTo(70)
            make.bottom.equalToSuperview()
        }
    }
}
