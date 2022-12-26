//
//  WalkStatusViewButton.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 26.12.2022.
//

import UIKit
import SnapKit
import Combine

class WalkStatusViewButton: UIButton {
    let viewModel: WalkViewModel
    var subscriptions = Set<AnyCancellable>()
    
    let iconView = UIImageView(image: .appImage(.logoWhite))
    
    let timeLabel = Label().then {
        $0.textColor = .appColor(.grayEmpty)
        $0.text = "99:12:24"
        $0.font = .montserratMedium(size: 16).monospacedDigitFont
        
    }
    
    let distanceLabel = Label().then {
        $0.textColor = .appColor(.labelOnButton)
        $0.text = "28, 35 км"
        $0.font = .montserratMedium(size: 22)
    }
    
    let stopIcon = UIImageView(image: .appImage(.stopWalk))
    
    init(viewModel: WalkViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        self.setupUI()
        self.setupBindings()
        
        self.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: isHighlighted ? 0.0 : 0.2, delay: 0.0, options: [.allowUserInteraction]) {
                self.alpha = self.isHighlighted ? 0.7 : 1.0
            }
        }
    }
    
    private func setupUI() {
        self.tintColor = .appColor(.black)
        self.backgroundColor = .appColor(.black)
        
        self.layer.cornerRadius = 116/2
        
        self.setTitleColor(.appColor(.black), for: .normal)
        self.titleLabel?.font = .montserratRegular(size: 16)
        
        [iconView, timeLabel, distanceLabel, stopIcon].forEach({self.addSubview($0)})
        
        self.snp.makeConstraints { make in
            make.height.width.equalTo(116)
        }
        
        iconView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        timeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(20)
        }
        
        distanceLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(timeLabel.snp.bottom).offset(2)
        }
        
        stopIcon.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(distanceLabel.snp.bottom).offset(10)
        }
    }
    
    func setupBindings() {
        viewModel.$state.sink { value in
            self.setState(state: value)
        }
        .store(in: &subscriptions)
        
        viewModel.$timeInterval.sink { interval in
            self.timeLabel.text = "\(String(format: "%02d", interval.hours)):\(String(format: "%02d", interval.minutes)):\(String(format: "%02d", interval.seconds))"
        }
        .store(in: &subscriptions)
    }
    
    func setState(state: WalkViewModel.State) {
        switch state {
        case .normal:
            iconView.isHidden = false
            timeLabel.isHidden = true
            distanceLabel.isHidden = true
            stopIcon.isHidden = true
        case .play:
            iconView.isHidden = true
            timeLabel.isHidden = false
            distanceLabel.isHidden = false
            stopIcon.isHidden = false
        case .pause:
            iconView.isHidden = true
            timeLabel.isHidden = false
            distanceLabel.isHidden = false
            stopIcon.isHidden = false
        }
    }
    
    @objc func buttonAction() {
        switch viewModel.state {
        case .normal: viewModel.startWalk()
        case .play: viewModel.stopWalk()
        case .pause:
            break
        }
    }
}
