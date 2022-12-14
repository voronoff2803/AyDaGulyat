//
//  ProfileViewController.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 22.10.2022.
//

import UIKit
import SnapKit


class ProfileEditViewController: AppRootViewController, TextFieldNextable {
    enum State {
        case dogProfile
        case personProfile
    }
    
    let personEditViewModel: PersonEditViewModel
    
    var state: ProfileEditViewController.State = .personProfile {
        didSet {
            switch self.state {
            case .dogProfile:
                self.dogsCollectionView.transform = .init(translationX: 50, y: 0)
                self.profileImageView.transform = .identity
            case .personProfile:
                self.dogsCollectionView.transform = .identity
                self.profileImageView.transform = .init(translationX: -50, y: 0)
            }
            
            UIView.animate(withDuration: 0.1) {
                switch self.state {
                case .dogProfile:
                    self.dogsCollectionView.isHidden = false
                    self.pageControlView.isHidden = false
                    self.dogsCollectionView.alpha = 1.0
                    self.pageControlView.alpha = 1.0
                    self.shadowView.alpha = 0.0
                    self.profileImageView.alpha = 0.0
                    self.dogsCollectionView.transform = .identity
                    self.profileImageView.transform = .init(translationX: -50, y: 0)
                case .personProfile:
                    self.dogsCollectionView.alpha = 0.0
                    self.pageControlView.alpha = 0.0
                    self.shadowView.isHidden = false
                    self.profileImageView.isHidden = false
                    self.shadowView.alpha = 1.0
                    self.profileImageView.alpha = 1.0
                    self.dogsCollectionView.transform = .init(translationX: 50, y: 0)
                    self.profileImageView.transform = .identity
                }
            } completion: { _ in
                switch self.state {
                case .dogProfile:
                    self.shadowView.isHidden = true
                    self.profileImageView.isHidden = true
                case .personProfile:
                    self.dogsCollectionView.isHidden = true
                    self.pageControlView.isHidden = true
                }
            }
        }
    }
    
    var dogs: [DogAvatarModel] = [] {
        didSet {
            self.pageControlView.numberOfPages = dogs.count
        }
    }
    
    let cameraButton = UIImageView().then {
        $0.image = .appImage(.cameraButton)
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
    
    let dismissButton = UIButton(type: .system).then {
        $0.setImage(.appImage(.dismiss), for: .normal)
        $0.tintColor = .appColor(.grayEmpty)
    }
    
    
    let profileImageView = UIImageView().then {
        $0.clipsToBounds = false
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 55
        $0.isHidden = true
        $0.image = .appImage(.emptyProfile)
    }
    
    let segmentedSelector = CustomSegmentedControl(frame: .zero, buttonTitle: ["Хозяин", "Собака"])
    
    
    var shadowView = UIView().then {
        let shadowLayer = CAShapeLayer()
        shadowLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 110, height: 110),
                                        cornerRadius: 55).cgPath
        shadowLayer.fillColor = UIColor.clear.cgColor
        
        shadowLayer.shadowColor = UIColor.darkGray.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 10.0, height: 10.0)
        shadowLayer.shadowOpacity = 0.2
        shadowLayer.shadowRadius = 16
        
        $0.layer.insertSublayer(shadowLayer, at: 0)
        $0.isHidden = true
    }
    
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
                                              collectionViewLayout: SnapCenterLayout(isLastUnreachable: true).then {
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
        $0.bounces = true
    }
    
    
    var selectedDogIndex: Int = 0 {
        didSet {
            if selectedDogIndex != oldValue {
                self.selectDogAvatar(at: selectedDogIndex)
            }
        }
    }
    
    init(personEditViewModel: PersonEditViewModel) {
        self.personEditViewModel = personEditViewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dogsCollectionView.register(DogAvatarCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        dogsCollectionView.dataSource = self
        dogsCollectionView.delegate = self
        dogsCollectionView.reloadData()
        DispatchQueue.main.async {
            self.dogsCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: false)
            self.updateCellsLayout()
        }
        
        dismissButton.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
        
        addChild(pageViewController)
        
        pageControlView.addTarget(self, action: #selector(pageControlHandle), for: .valueChanged)
        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        self.dogs = [.empty]
        
        setupUI()
        
        state = { self.state }()
        
        pageViewController.setViewControllers([PersonEditViewController(viewModel: personEditViewModel)], direction: .forward, animated: false)
        
        segmentedSelector.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        if selectedDogIndex == 0 {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                self.dogsCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: false)
//                self.updateCellsLayout()
//                
//                UIView.animate(withDuration: 0.1) {
//                    self.dogsCollectionView.alpha = 1.0
//                }
//            }
//        }
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        NotificationCenter.default.post(name: .userProfileUpdate, object: "nil")
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
        pageViewController.setViewControllers([PersonEditViewController(viewModel: personEditViewModel)], direction: .reverse, animated: true)
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
                UIView.animate(withDuration: 0.1, delay: 0.0, options: [.beginFromCurrentState]) {
                    cell.cameraButton.alpha = 1.0
                }
            } else {
                UIView.animate(withDuration: 0.1, delay: 0.0, options: [.beginFromCurrentState]) {
                    cell.cameraButton.alpha = 0.0
                }
            }
            
            if offsetPercentage > 0.7 {
                UIView.animate(withDuration: 0.2, delay: 0.0, options: [.beginFromCurrentState]) {
                    cell.imageView.layer.borderWidth = 0
                    cell.shadowLayer.opacity = 1.0
                }
            } else {
                UIView.animate(withDuration: 0.2, delay: 0.0, options: [.beginFromCurrentState]) {
                    cell.imageView.layer.borderWidth = 3
                    cell.shadowLayer.opacity = 0.0
                }
            }
                
        }
    }
    
    func selectDogAvatar(at index: Int) {
        pageControlView.currentPage = index + 1
    }
    
    @objc func dismissAction() {
        self.dismiss(animated: true)
    }
    
    
    func setupUI() {
        self.view.addSubview(contentView)
        
        [dogsCollectionView, pageControlView, dismissButton, pageView, shadowView, profileImageView, segmentedSelector].forEach({self.view.addSubview($0)})
        
        self.profileImageView.addSubview(cameraButton)
        
        self.view.backgroundColor = .clear
        
        cameraButton.snp.makeConstraints { make in
            make.centerX.equalTo(self.profileImageView)
            make.centerY.equalTo(self.profileImageView.snp.bottom)
        }
        
        segmentedSelector.snp.makeConstraints { make in
            make.top.equalTo(dogsCollectionView.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview().inset(28)
            make.height.equalTo(50)
        }
        
        pageView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(segmentedSelector.snp.bottom)
            make.bottom.equalTo(view.safeAreaLayoutGuide).priority(.low)
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
        
        profileImageView.snp.makeConstraints { make in
            make.height.width.equalTo(110)
            make.centerX.equalToSuperview()
            make.centerY.equalTo(contentView.snp.top)
        }
        
        shadowView.snp.makeConstraints { make in
            make.center.equalTo(profileImageView)
            make.size.equalTo(profileImageView)
        }
    }
}


extension ProfileEditViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dogs.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DogAvatarCollectionViewCell
        
        switch indexPath.row {
        case dogs.count:
            cell.setup(model: DogAvatarModel.add)
        default:
            cell.setup(model: dogs[indexPath.row])
        }
        
        
        return cell
    }
}


extension ProfileEditViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.updateCellsLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == dogs.count {
            dogs.append(DogAvatarModel.empty)
            self.dogsCollectionView.insertItems(at: [indexPath])
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.dogsCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
        } else {
            if (collectionView.cellForItem(at: indexPath)?.frame.width ?? 0) > 90 {
                dogs[indexPath.row] = .normal(.appImage(.content2))
                if let cell = collectionView.cellForItem(at: indexPath) as? DogAvatarCollectionViewCell {
                    cell.setup(model: dogs[indexPath.row])
                }
            }
            
            self.dogsCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
        
        
        self.updateCellsLayout()
    }
}


extension ProfileEditViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if viewController is PersonEditViewController { return nil }
        
        return PersonEditViewController(viewModel: personEditViewModel)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController is DogProfileViewController { return nil }

        return DogProfileViewController()
    }
}


extension ProfileEditViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed, let contentViewController = pageViewController.viewControllers?.first else { return }
        
        if contentViewController is DogProfileViewController {
            self.state = .dogProfile
            self.segmentedSelector.setIndex(index: 1)
        } else {
            self.state = .personProfile
            self.segmentedSelector.setIndex(index: 0)
        }
    }
}


extension ProfileEditViewController: CustomSegmentedControlDelegate {
    func change(to index: Int) {
        switch index {
        case 0:
            selectPersonAction()
        case 1:
            selectDogAction()
        default:
            selectPersonAction()
        }
    }
}
