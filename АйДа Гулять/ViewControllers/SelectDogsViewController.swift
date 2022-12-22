//
//  SelectDogsViewController.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 22.12.2022.
//

import UIKit
import Combine
import SnapKit
import BottomSheet

class SelectDogsViewController: UIViewController, ScrollableBottomSheetPresentedController {
    var scrollView: UIScrollView?
    
    private var subscriptions = Set<AnyCancellable>()
    let viewModel: SelectDogsViewModel
    
    private let activityIndicator = ActivityIndicator()
    private let errorIndicator = ErrorIndicator()
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: CollectionViewCenteredFlowLayout().then({
        $0.itemSize = CGSize(width: 128, height: 170)
        $0.scrollDirection = .vertical
    }))
    
    let titleLabel = Label().then {
        $0.text = "С кем пойдешь гулять?"
        $0.font = .montserratRegular(size: 20)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    let continueButton = DefaultButton().then {
        $0.setTitle("Пойти гулять", for: .normal)
    }
    
    init(viewModel: SelectDogsViewModel) {
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
        collectionView.register(SelectDogCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        // Do any additional setup after loading the view.
        
        scrollView = collectionView.scrollView
    }
    
    func setupUI() {
        self.view.backgroundColor = .appColor(.backgroundFirst)
        self.collectionView.backgroundColor = .clear
        
        [titleLabel ,collectionView, continueButton].forEach({ view.addSubview($0) })
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(30)
            make.centerX.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview().inset(50)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        continueButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide).inset(28)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func setupBindings() {
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        preferredContentSize = CGSize(width: collectionView.contentSize.width, height: collectionView.contentSize.height + 180)
    }
}
