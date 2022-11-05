//
//  ListSearchViewController.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 28.10.2022.
//

import UIKit
import Combine

class ListSearchViewController: UIViewController, TextFieldNextable {
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
    
    var selectedIndex: Int? {
        willSet{
            if let selectedIndex = self.displayedItems.firstIndex(where: {$0.0 == selectedIndex}) {
                (resultTableView.cellForRow(at: IndexPath(row: selectedIndex, section: 0)) as? ListTableViewCell)?.isCurrent = false
            }
            
            if let selectedIndex = self.displayedItems.firstIndex(where: {$0.0 == newValue}) {
                (resultTableView.cellForRow(at: IndexPath(row: selectedIndex, section: 0)) as? ListTableViewCell)?.isCurrent = true
            }
        }
    }
    
    let textField = DefaultTextField().then {
        $0.autocorrectionType = .no
        $0.placeholder = "Поиск"
        $0.setLeftImage(image: .appImage(.searchIcon).withTintColor(.appColor(.grayEmpty)))
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
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        self.handler(selectedIndex)
        
        super.dismiss(animated: flag, completion: completion)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dismissButton = UIBarButtonItem(image: .appImage(.dismiss), style: .done, target: self, action: #selector(dismissAction)).then {
            $0.tintColor = .appColor(.black)
        }
        
        navigationItem.setRightBarButton(dismissButton, animated: false)
        
        resultTableView.register(ListTableViewCell.self, forCellReuseIdentifier: "cell")
        resultTableView.delegate = self
        resultTableView.dataSource = self
        resultTableView.separatorStyle = .none
        
        textField.textPublisher.sink { text in
            self.searchString = text ?? ""
        }.store(in: &subscriptions)
        
        setupUI()
    }
    
    func setupUI() {
        self.view.backgroundColor = .appColor(.backgroundFirst)
        
        [textField, resultTableView, emptyLabelView].forEach({ self.view.addSubview($0) })
        
        textField.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide).inset(28)
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(10)
        }
        
        resultTableView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(textField.snp.bottom)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        emptyLabelView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide).inset(28)
            make.top.equalTo(textField.snp.bottom).offset(28)
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
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
