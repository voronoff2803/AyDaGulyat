//
//  WalkDoneViewController.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 26.12.2022.
//

import UIKit

class WalkDoneViewController: UIViewController {
    enum State {
        case loading
        case normal
    }
    
    let viewModel: WalkViewModel
    
    let titleLabel = Label().then {
        $0.text = "Завершить прогулку?"
        $0.font = .montserratRegular(size: 20)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    let imageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 4
    }
    
    let continueButton = DefaultButton().then {
        $0.setTitle("Да, завершить", for: .normal)
    }
    
    let cancelButton = DefaultButton(style: .bordered).then {
        $0.setTitle("Нет, хочу погулять еще", for: .normal)
    }

    var state: WalkDoneViewController.State = .loading {
        didSet {
            switch state {
            case .loading:
                break
            case .normal:
                break
            }
        }
    }
    
    init(viewModel: WalkViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .appColor(.backgroundFirst)
        setupUI()
    }
    

    func setupUI() {
        let infoStackView = UIStackView(arrangedSubviews: [InfoView(), InfoView(), InfoView()])
        infoStackView.axis = .horizontal
        infoStackView.distribution = .fillEqually
        
        [titleLabel, imageView, infoStackView, continueButton, cancelButton].forEach({self.view.addSubview($0)})
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(30)
            make.centerX.equalToSuperview()
        }
        
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        imageView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(28)
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
        }
        
        imageView.image = .appImage(.content5)
        
        infoStackView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(15)
            make.horizontalEdges.equalToSuperview().inset(28)
        }
        
        continueButton.snp.makeConstraints { make in
            make.top.equalTo(infoStackView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(28)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(continueButton.snp.bottom).offset(15)
            make.horizontalEdges.equalToSuperview().inset(28)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        preferredContentSize = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        preferredContentSize = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }

}


class InfoView: UIView {
    let titleLabel = UILabel().then {
        $0.textColor = .appColor(.black)
        $0.font = .montserratSemiBold(size: 16)
        $0.text = "9:41"
    }
    
    let descriptionLabel = UILabel().then {
        $0.textColor = .appColor(.grayEmpty)
        $0.font = .montserratRegular(size: 13)
        $0.text = "Окончание"
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        setupUI()
    }
    
    func setupUI() {
        [titleLabel, descriptionLabel].forEach({self.addSubview($0)})
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
