//
//  CreateMarkerPanel.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 28.12.2022.
//

import UIKit

class CreateMarkerPanel: UIViewController {
    let viewModel: WalkViewModel
    
    let titleLabel = Label().then {
        $0.text = "Добавление метки"
        $0.font = .montserratRegular(size: 20)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    let segmentedSelector = CustomSegmentedControl(frame: .zero, buttonTitle: ["Опасность", "Потерял", "Нашёл"])
    
    
    let continueButton = DefaultButton().then {
        $0.setTitle("Да, завершить", for: .normal)
    }
    
    let cancelButton = DefaultButton(style: .bordered).then {
        $0.setTitle("Нет, хочу погулять еще", for: .normal)
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
        
        [titleLabel, segmentedSelector].forEach({self.view.addSubview($0)})
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(30)
            make.centerX.equalToSuperview()
        }
        
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        segmentedSelector.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(28)
            make.height.equalTo(40)
        }

        
//        continueButton.snp.makeConstraints { make in
//            make.top.equalTo(infoStackView.snp.bottom).offset(20)
//            make.horizontalEdges.equalToSuperview().inset(28)
//        }
//
//        cancelButton.snp.makeConstraints { make in
//            make.top.equalTo(continueButton.snp.bottom).offset(15)
//            make.horizontalEdges.equalToSuperview().inset(28)
//            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
//        }
    }
}
