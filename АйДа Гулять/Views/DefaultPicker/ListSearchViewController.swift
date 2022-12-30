//
//  ListSearchViewController.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 28.10.2022.
//

import UIKit
import Combine

class ListSearchViewController: AppRootViewController, TextFieldNextable, Reloadable {
    private var subscriptions = Set<AnyCancellable>()
    
    var items: [(Int, String)] {
        didSet {
            self.resultTableView.reloadData()
        }
    }
    
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
    
    let handler: (Int?)->()
    
    init(items: [String], selectedIndex: Int? = nil , handler: @escaping (Int?)->()) {
        self.selectedIndex = selectedIndex
        self.items = items.enumerated().map({ ($0.offset, $0.element) })
        self.handler = handler
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @Published var selectedIndex: Int? {
        willSet{
            if let selectedIndex = self.displayedItems.firstIndex(where: {$0.0 == selectedIndex}) {
                (resultTableView.cellForRow(at: IndexPath(row: selectedIndex, section: 0)) as? ListTableViewCell)?.isCurrent = false
            }
            
            if let selectedIndex = self.displayedItems.firstIndex(where: {$0.0 == newValue}) {
                (resultTableView.cellForRow(at: IndexPath(row: selectedIndex, section: 0)) as? ListTableViewCell)?.isCurrent = true
            }
        }
    }
    
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
        self.handler(selectedIndex)
        
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
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
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


extension ListSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = displayedItems[indexPath.row].0
        
        self.view.endEditing(false)
        self.navigationController?.view.endEditing(true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            self.dismiss(animated: true, completion: nil)
        }
    }
}


extension ListSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ListTableViewCell
        cell.contentLabel.text = self.displayedItems[indexPath.row].1
        
        let displayedIndex = displayedItems.firstIndex(where: {$0.0 == selectedIndex})
        
        if displayedIndex == indexPath.row {
            cell.isCurrent = true
        } else {
            cell.isCurrent = false
        }
        return cell
    }
}
