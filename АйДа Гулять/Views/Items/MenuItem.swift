//
//  MenuItemContent.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 07.01.2023.
//

import UIKit
import Carbon


struct MenuItem: IdentifiableComponent {
    var id: String {
        title
    }
    let route: Coordinator.Route
    let icon: UIImage
    let title: String
    let menuViewController: MenuViewController
    
    func renderContent() -> MenuItemContent {
        MenuItemContent()
    }
    
    func render(in content: MenuItemContent) {
        content.smallIcon.image = icon
        content.titleLabel.text = title
        content.onSelect = {
            menuViewController.coordinator.route(context: menuViewController, to: route, parameters: nil)
        }
    }
}


class MenuItemContent: UIControl {
    var onSelect: (() -> Void)?
    
    let titleLabel = UILabel().then {
        $0.textColor = .appColor(.black)
        $0.font = .montserratRegular(size: 16)
        $0.text = "Моя визитка"
    }
    
    let smallIcon = UIImageView(image: .appImage(.openEye), highlightedImage: nil)
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: isHighlighted ? 0.0 : 0.3) {
                self.alpha = self.isHighlighted ? 0.3 : 1
            }
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        addTarget(self, action: #selector(selected), for: .touchUpInside)
    }
    
    
    func setup(menuItem: MenuItem) {
        titleLabel.text = menuItem.title
        smallIcon.image = menuItem.icon
    }
        
    func setupUI() {
        backgroundColor = .appColor(.backgroundFirst)
        
        tintColor = .appColor(.black)
        
        [titleLabel, smallIcon].forEach({self.addSubview($0)})
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(76)
        }
        
        smallIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(28)
        }
    }
    
    @objc func selected() {
        onSelect?()
    }
}
