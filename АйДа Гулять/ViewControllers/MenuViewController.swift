//
//  MenuViewController.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 24.12.2022.
//

import UIKit
import BottomSheet

class MenuViewController: AppRootViewController, ScrollableBottomSheetPresentedController {
    var scrollView: UIScrollView?
    
    let coordinator: Coordinator
    
    let menuItems: [MenuItem] = [ MenuItem(route: .auth, icon: .appImage(.menuQR), title: "Моя визитка"),
                                  MenuItem(route: .auth, icon: .appImage(.menuWalks), title: "Мои прогулки"),
                                  MenuItem(route: .auth, icon: .appImage(.menuFinds), title: "Потерялись | Нашлись"),
                                  MenuItem(route: .auth, icon: .appImage(.menuShelters), title: "Приюты"),
                                  MenuItem(route: .knowledgeCollection, icon: .appImage(.menuKnowledge), title: "База знаний"),
                                  MenuItem(route: .auth, icon: .appImage(.menuTutor), title: "Туториал"),
                                  MenuItem(route: .auth, icon: .appImage(.menuSettings), title: "Настройки"),
                                  MenuItem(route: .profileEdit, icon: .appImage(.closeEye), title: "Создать метку"),]
    
    let tableView = DynamicTableView()
    
    let titleLabel = UILabel().then {
        $0.textColor = .appColor(.black)
        $0.font = .montserratSemiBold(size: 16)
        $0.text = "К нам не подходить"
    }
    
    let descriptionLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textColor = .appColor(.grayEmpty)
        $0.font = .montserratRegular(size: 14)
        $0.text = "Во время прогулки все увидят, что к вам пока не подходить"
    }
    
    let switchView = UISwitch().then {
        $0.onTintColor = .appColor(.black)
    }

    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView = tableView.parentScrollView
        
        view.backgroundColor = .appColor(.backgroundFirst)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(MenuCell.self, forCellReuseIdentifier: "cell")
        setupUI()
    }
    

    func setupUI() {
        [titleLabel, descriptionLabel, switchView, tableView].forEach({self.view.addSubview($0)})
        
        tableView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(descriptionLabel.snp.bottom)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.horizontalEdges.equalToSuperview().inset(28)
        }
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().inset(28)
            make.right.equalTo(switchView.snp.left).offset(-28)
        }
        
        switchView.snp.makeConstraints { make in
            make.centerY.equalTo(descriptionLabel)
            make.right.equalToSuperview().inset(28)
        }
        
        tableView.separatorStyle = .singleLine
        tableView.rowHeight = 70.0
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


extension MenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuCell
        let menuItem = menuItems[indexPath.row]
        cell.setup(menuItem: menuItem)
        return cell
    }
}

extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menuItem = menuItems[indexPath.row]
        
        self.coordinator.route(context: self, to: menuItem.route, parameters: nil)
    }
}

struct MenuItem {
    let route: Coordinator.Route
    let icon: UIImage
    let title: String
}
