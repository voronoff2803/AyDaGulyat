//
//  ListSearchViewControllerMany.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 18.12.2022.
//

import UIKit
import Combine

class ListSearchViewControllerMany: AppRootViewController, TextFieldNextable, Reloadable {
    var items: [(Int, String)] {
        didSet {
            self.resultTableView.reloadData()
        }
    }
    
    private var subscriptions = Set<AnyCancellable>()
    
    var searchString: String = "" {
        didSet {
            self.resultTableView.reloadData()
        }
    }
    
    var displayedItems: [(Int, String)] {
        if searchString.isEmpty {
            self.emptyLabelView.isHidden = true
            return self.items
        } else {
            let result = self.items.filter({$0.1.lowercased().contains(searchString.lowercased())})
            self.emptyLabelView.isHidden = result.isEmpty ? false : true
            return result
        }
    }
    
    let handler: (Set<Int>)->()
    
    init(items: [String], selectedIndexes: Set<Int> = [] , handler: @escaping (Set<Int>)->()) {
        self.selectedIndexes = selectedIndexes
        self.items = items.enumerated().map({ ($0.offset, $0.element) })
        self.handler = handler
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @Published var selectedIndexes: Set<Int>
    
    let emptyLabelView = UILabel().then {
        $0.text =
        """
        К сожалению, по вашему запросу ничего не найдено.

        Убедитесь, что название написано правильно. Попробуйте написать название по-другому или сократить запрос.
        """
        $0.font = UIFont.montserratRegular(size: 14)
        $0.textColor = UIColor.appColor(.grayEmpty)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    let resultTableView = UITableView().then {
        $0.backgroundColor = .clear
    }
    
    func reload(values: [String]) {
        self.items = values.enumerated().map({ ($0.offset, $0.element) })
        resultTableView.reloadData()
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        self.handler(selectedIndexes)
        
        super.dismiss(animated: flag, completion: completion)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let close = self.navigationController?.getTabBarItem(type: .close),
           let search = self.navigationController?.getTabBarItem(type: .search) {
            navigationItem.setRightBarButtonItems([close, search], animated: true)
        }
        navigationController?.closeButton?.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
        
        resultTableView.register(ListTableViewCell.self, forCellReuseIdentifier: "cell")
        resultTableView.delegate = self
        resultTableView.dataSource = self
        resultTableView.separatorStyle = .none
        
        navigationController?.searchBarField.textPublisher.sink { text in
            self.searchString = text ?? ""
        }.store(in: &subscriptions)
        
        setupUI()
        
    }
    
    func setupUI() {
        self.view.backgroundColor = .appColor(.backgroundFirst)
        
        [resultTableView, emptyLabelView].forEach({ self.view.addSubview($0) })
        
        resultTableView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.top.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        emptyLabelView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide).inset(28)
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(40)
        }
    }
    
    @objc func dismissAction() {
        self.dismiss(animated: true)
    }
}


extension ListSearchViewControllerMany: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedIndex = self.displayedItems[indexPath.row].0
        
        if selectedIndexes.contains(selectedIndex) {
            selectedIndexes.remove(selectedIndex)
        } else {
            selectedIndexes.insert(selectedIndex)
        }
        
        (resultTableView.cellForRow(at: indexPath) as? ListTableViewCell)?.isCurrent = selectedIndexes.contains(selectedIndex)
        
        self.view.endEditing(false)
        self.navigationController?.view.endEditing(true)
    }
}


extension ListSearchViewControllerMany: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ListTableViewCell
        
        let item = self.displayedItems[indexPath.row]
        
        cell.contentLabel.text = item.1
        
        if selectedIndexes.contains(item.0) {
            cell.isCurrent = true
        } else {
            cell.isCurrent = false
        }
        
        return cell
    }
}
