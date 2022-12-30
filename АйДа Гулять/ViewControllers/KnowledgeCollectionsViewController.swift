//
//  KnowledgeCollectionsViewController.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 22.12.2022.
//

import UIKit
import Combine
import SnapKit

class KnowledgeCollectionsViewController: AppRootViewController {
    private var subscriptions = Set<AnyCancellable>()
    let viewModel: KnowledgeCollectionViewModel
    
    private let activityIndicator = ActivityIndicator()
    private let errorIndicator = ErrorIndicator()
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: CollectionViewCenteredFlowLayout().then({
        $0.itemSize = CGSize(width: 180, height: 230)
        $0.scrollDirection = .vertical
    }))
    
    init(viewModel: KnowledgeCollectionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupBindings()
        
        collectionView.dataSource = viewModel
        collectionView.delegate = viewModel
        collectionView.register(KnowledgeCollectionCell.self, forCellWithReuseIdentifier: "cell")
        
        if let search = self.navigationController?.getTabBarItem(type: .search),
           let close = self.navigationController?.getTabBarItem(type: .close){
            navigationItem.setRightBarButtonItems([close, search], animated: true)
            //navigationItem.setLeftBarButtonItems([close], animated: true)
            //navigationItem.leftBarButtonItem = close
            //self.navigationController?.navigationBar.topItem?.backBarButtonItem = close
            //navigationItem.backBarButtonItem = close
            //navigationItem.setHidesBackButton(false, animated: true)
        }
        navigationController?.closeButton?.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
        
        
        // Do any additional setup after loading the view.
    }
    
    @objc func dismissAction() {
        self.viewModel.coordinator.route(context: self, to: .dismiss, parameters: nil)
    }
    
    func setupUI() {
        self.title = "База знаний"
        
        self.view.backgroundColor = .appColor(.backgroundFirst)
        self.collectionView.backgroundColor = .clear
        self.collectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        
        [collectionView].forEach({ view.addSubview($0) })
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func setupBindings() {
    }
}
