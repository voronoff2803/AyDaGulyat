//
//  KnowledgeDetailsCollectionViewController.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 25.12.2022.
//

import UIKit
import Combine
import SnapKit

class KnowledgeDetailsCollectionViewController: AppRootViewController {
    private var subscriptions = Set<AnyCancellable>()
    let viewModel: KnowledgeDetailsCollectionViewModel
    
    lazy var cardTransitionInteractor: CSCardTransitionInteractor? = CSCardTransitionInteractor(viewController: self)
    
    private let activityIndicator = ActivityIndicator()
    private let errorIndicator = ErrorIndicator()
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then({
        $0.itemSize = CGSize(width: 180, height: 230)
        $0.scrollDirection = .vertical
    }))
    
    init(viewModel: KnowledgeDetailsCollectionViewModel ) {
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
        collectionView.register(KnowledgeDetailHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: KnowledgeDetailHeaderView.identifier)
        
        if let search = self.navigationController?.getTabBarItem(type: .search) {
            navigationItem.setRightBarButtonItems([search], animated: true)
        }
    }
    
    func setupUI() {
        self.title = "Уход за шерстью собаки"
        
        self.view.backgroundColor = .appColor(.backgroundFirst)
        self.collectionView.backgroundColor = .clear
        self.collectionView.contentInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        
        [collectionView].forEach({ view.addSubview($0) })
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func setupBindings() {
    }
}



//extension KnowledgeDetailsCollectionViewController: CSCardPresentedView {
//    var cardTransitionInteractor: CSCardTransitionInteractor? {
//        //
//    }
//}
