//
//  ProfileViewController.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 22.10.2022.
//

import UIKit
import SnapKit


class ProfileViewController: AppRootViewController, TextFieldNextable {
    enum State {
        case dogProfile
        case personProfile
    }
    
    var state: ProfileViewController.State = .dogProfile {
        didSet {
            UIView.animate(withDuration: 0.1) {
                switch self.state {
                case .dogProfile:
                    self.dogProfileSelectedConstraint?.isActive = true
                    self.personProfileSelectedConstraint?.isActive = false
                case .personProfile:
                    self.dogProfileSelectedConstraint?.isActive = false
                    self.personProfileSelectedConstraint?.isActive = true
                }
                self.modeSelector.layoutSubviews()
            }
        }
    }
    
    var dogs: [DogAvatarModel] = [] {
        didSet {
            self.pageControlView.numberOfPages = dogs.count
        }
    }
    
    let contentView = UIView().then {
        $0.backgroundColor = .appColor(.backgroundFirst)
        $0.layer.cornerRadius = 20
        $0.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        $0.clipsToBounds = false
    }
    
    let pageControlView = UIPageControl().then {
        $0.pageIndicatorTintColor = .appColor(.grayEmpty)
        $0.currentPageIndicatorTintColor = .appColor(.black)
        $0.isUserInteractionEnabled = false
    }
    
    let redView = UIView().then {
        $0.backgroundColor = .red
    }
    
    let dismissButton = UIButton(type: .system).then {
        $0.setImage(.appImage(.dismiss), for: .normal)
        $0.tintColor = .appColor(.grayEmpty)
    }
    
    let selectPersonButton = LabelButton().then {
        $0.setTitle("Хозяин", for: .normal)
        $0.setTitleColor(.appColor(.black), for: .normal)
    }
    
    let selectDogButton = LabelButton().then {
        $0.setTitle("Собака", for: .normal)
        $0.setTitleColor(.appColor(.black), for: .normal)
    }
    
    let modeSelector = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
    }
    
    let selectedLineView = UIView().then {
        $0.backgroundColor = .appColor(.black)
    }
    
    let selectedLineViewBackground = UIView().then {
        $0.backgroundColor = .appColor(.lightGray)
    }
    
    var dogProfileSelectedConstraint: Constraint?
    var personProfileSelectedConstraint: Constraint?
    
    let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    lazy var pageView: UIView! = {
        self.pageViewController.view
    }()
    
//    let pageView = UIView().then {
//        $0.backgroundColor = .red
//        $0.setContentHuggingPriority(.defaultHigh, for: .vertical)
//        $0.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
//    }
    
    let dogsCollectionView = UICollectionView(frame: .zero,
                                                 collectionViewLayout:
                                                    PagingCollectionViewLayout().then {
                                                        $0.scrollDirection = .horizontal
                                                        $0.itemSize = .init(width: 110, height: 110)
                                                        $0.minimumLineSpacing = 10
        $0.sectionInset = .init(top: 0, left: UIScreen.main.bounds.width / 2 - 55,
                                bottom: 0, right:  UIScreen.main.bounds.width / 2 - 55)
    }).then {
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        $0.decelerationRate = .fast
        $0.clipsToBounds = false
    }
    
    var selectedDogIndex: Int = 0 {
        didSet {
            if selectedDogIndex != oldValue {
                self.selectDogAvatar(at: selectedDogIndex)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dogsCollectionView.register(DogAvatarCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        dogsCollectionView.dataSource = self
        dogsCollectionView.delegate = self
        dogsCollectionView.reloadData()
        dogsCollectionView.alpha = 0.0
        
        dismissButton.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
        
        addChild(pageViewController)
        
        pageControlView.addTarget(self, action: #selector(pageControlHandle), for: .valueChanged)
        pageViewController.delegate = self
        pageViewController.dataSource = self
        pageViewController.setViewControllers([DogProfileViewController()], direction: .forward, animated: false)
        
        self.dogs = [.empty]
        
        modeSelector.addArrangedSubview(selectPersonButton)
        modeSelector.addArrangedSubview(selectDogButton)
        
        selectDogButton.addTarget(self, action: #selector(selectDogAction), for: .touchUpInside)
        selectPersonButton.addTarget(self, action: #selector(selectPersonAction), for: .touchUpInside)
    
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if selectedDogIndex == 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.dogsCollectionView.scrollToItem(at: IndexPath(row: 1, section: 0), at: .centeredHorizontally, animated: false)
                self.updateCellsLayout()
                
                UIView.animate(withDuration: 0.1) {
                    self.dogsCollectionView.alpha = 1.0
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        let button1 = DefaultButton(style: .filledAlert).then {
//            $0.setTitle("Разрешить", for: .normal)
//        }
//
//        let button2 = DefaultButton(style: .borderedAlert).then {
//            $0.setTitle("Не сейчас", for: .normal)
//        }
//
//        showAlert(buttons: [button1, button2])
    }
    
    @objc private func pageControlHandle(sender: UIPageControl){
        //dogsCollectionView.scrollToItem(at: IndexPath(row: sender.currentPage + 1, section: 0), at: .centeredHorizontally, animated: true)
        print(sender.currentPage)
    }
    
    @objc func selectDogAction() {
        if state == .dogProfile { return }
        
        state = .dogProfile
        pageViewController.setViewControllers([DogProfileViewController()], direction: .forward, animated: true)
    }
    
    @objc func selectPersonAction() {
        if state == .personProfile { return }
        
        state = .personProfile
        pageViewController.setViewControllers([PersonProfileViewController()], direction: .reverse, animated: true)
    }
    
    func updateCellsLayout()  {
        let centerX = dogsCollectionView.contentOffset.x + (dogsCollectionView.frame.size.width)/2
        for cellSource in dogsCollectionView.visibleCells {
            let cell = cellSource as! DogAvatarCollectionViewCell
            var offsetX = centerX - cell.center.x
            if offsetX < 0 {
                offsetX *= -1
            }
            var offsetPercentage = -(offsetX / dogsCollectionView.bounds.width) + 1.0
            offsetPercentage = offsetPercentage * offsetPercentage
            if offsetPercentage < 0.5 {
                offsetPercentage = 0.5
            }
            
            cell.layer.transform = CATransform3DScale(CATransform3DIdentity, offsetPercentage, offsetPercentage, offsetPercentage)
            
            if offsetPercentage > 0.9 {
                if let indexPath = dogsCollectionView.indexPath(for: cell) {
                    selectedDogIndex = indexPath.row - 1
                }
                UIView.animate(withDuration: 0.1) {
                    cell.cameraButton.alpha = 1.0
                }
            } else {
                UIView.animate(withDuration: 0.1) {
                    cell.cameraButton.alpha = 0.0
                }
            }
        }
    }
    
    func selectDogAvatar(at index: Int) {
        pageControlView.currentPage = index
    }
    
    @objc func dismissAction() {
        self.dismiss(animated: true)
    }
    
    
    func setupUI() {
        self.view.addSubview(contentView)
        
        [dogsCollectionView, pageControlView, dismissButton, pageView, modeSelector].forEach({self.view.addSubview($0)})
        
        modeSelector.addSubview(selectedLineViewBackground)
        modeSelector.addSubview(selectedLineView)
        
        self.view.backgroundColor = .clear
        
        modeSelector.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(28)
            make.top.equalTo(pageControlView.snp.bottom).offset(0)
            make.height.equalTo(60)
        }
        
        pageView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(modeSelector.snp.bottom)
            make.bottom.equalToSuperview().priority(.low)
        }
        
        pageView.tag = 22
        keyboardAvoidView = pageView
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(80)
            make.bottom.horizontalEdges.equalToSuperview()
        }
        
        dogsCollectionView.snp.makeConstraints { make in
            make.height.equalTo(110)
            make.horizontalEdges.equalToSuperview()
            make.centerY.equalTo(contentView.snp.top)
        }
        
        pageControlView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(dogsCollectionView.snp.bottom).offset(20)
        }
        
        dismissButton.snp.makeConstraints { make in
            make.right.top.equalTo(contentView).inset(16)
        }
        
        selectedLineView.snp.makeConstraints { make in
            make.height.equalTo(2)
            make.bottom.equalTo(modeSelector)
            
            dogProfileSelectedConstraint = make.horizontalEdges.equalTo(selectDogButton).constraint
            personProfileSelectedConstraint = make.horizontalEdges.equalTo(selectPersonButton).priority(.low).constraint
        }
        
        selectedLineViewBackground.snp.makeConstraints { make in
            make.height.equalTo(2)
            make.bottom.equalTo(modeSelector)
            make.horizontalEdges.equalTo(modeSelector)
        }
    }
}


extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dogs.count + 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DogAvatarCollectionViewCell
        
        switch indexPath.row {
        case 0:
            cell.setup(model: DogAvatarModel.spacer)
        case dogs.count + 1:
            cell.setup(model: DogAvatarModel.add)
        default:
            cell.setup(model: dogs[indexPath.row - 1])
        }
        
        
        return cell
    }
}


extension ProfileViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.updateCellsLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == dogs.count + 1 {
            dogs.append(DogAvatarModel.empty)
            self.dogsCollectionView.insertItems(at: [indexPath])
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.dogsCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
        } else {
            if (collectionView.cellForItem(at: indexPath)?.frame.width ?? 0) > 90 {
                dogs[indexPath.row - 1] = .normal(.appImage(.content2))
                if let cell = collectionView.cellForItem(at: indexPath) as? DogAvatarCollectionViewCell {
                    cell.setup(model: dogs[indexPath.row - 1])
                }
            }
            
            self.dogsCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
        
        
        self.updateCellsLayout()
    }
}


extension ProfileViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if viewController is PersonProfileViewController { return nil }
        
        return PersonProfileViewController()
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController is DogProfileViewController { return nil }

        return DogProfileViewController()
    }
}


extension ProfileViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed, let contentViewController = pageViewController.viewControllers?.first else { return }
        
        if contentViewController is DogProfileViewController {
            self.state = .dogProfile
        } else {
            self.state = .personProfile
        }
    }
}
