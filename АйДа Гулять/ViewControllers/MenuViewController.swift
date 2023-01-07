//
//  MenuViewController.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 24.12.2022.
//

import UIKit
import BottomSheet
import Carbon

class MenuViewController: AppRootViewController, ScrollableBottomSheetPresentedController {
    var scrollView: UIScrollView?
    
    let coordinator: Coordinator
    
    lazy var menuItems: [MenuItem] = [ MenuItem(route: .auth, icon: .appImage(.menuQR), title: "Моя визитка", menuViewController: self),
                                  MenuItem(route: .selectDogs, icon: .appImage(.menuWalks), title: "Мои прогулки", menuViewController: self),
                                  MenuItem(route: .walkDone, icon: .appImage(.menuFinds), title: "Потерялись | Нашлись", menuViewController: self),
                                  MenuItem(route: .profileEdit, icon: .appImage(.menuShelters), title: "Приюты", menuViewController: self),
                                  MenuItem(route: .knowledgeCollection, icon: .appImage(.menuKnowledge), title: "База знаний", menuViewController: self),
                                  MenuItem(route: .auth, icon: .appImage(.menuTutor), title: "Туториал", menuViewController: self),
                                  MenuItem(route: .bigProfile, icon: .appImage(.menuSettings), title: "Настройки", menuViewController: self)]
    
    let tableView = DynamicTableView()
    
    let renderer = Renderer(
        adapter: UITableViewAdapter(),
        updater: UITableViewUpdater()
    )
    
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
        
        setupUI()
        
        renderer.target = tableView
        renderer.render {
            Group(of: menuItems) { item in
                item
            }
        }
    }
    

    func setupUI() {
        [titleLabel, descriptionLabel, switchView, tableView].forEach({self.view.addSubview($0)})
        
        tableView.backgroundColor = .appColor(.backgroundFirst)
        
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
            make.height.equalTo(52)
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
        preferredContentSize = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize) -
        CGSize(width: 0, height: view.safeAreaInsets.bottom - 10)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        preferredContentSize = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize) -
        CGSize(width: 0, height: view.safeAreaInsets.bottom - 10)
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
