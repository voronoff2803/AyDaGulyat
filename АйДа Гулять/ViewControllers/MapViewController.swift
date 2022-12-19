//
//  MapViewController.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 23.10.2022.
//

import UIKit
import SnapKit
import Combine

class MapViewController: UIViewController, TextFieldNextable {
    enum State {
        case search
        case normal
        case showDogs
    }
    
    private var subscriptions = Set<AnyCancellable>()
    
    var searchResultCount = 0
    
    var bottomMapPositionButton: Constraint!
    var bottomCallToActionButton: Constraint!
    
    let searchButton = UIButton(type: .system).then {
        $0.setImage(.appImage(.searchButton), for: .normal)
    }
    
    let searchField = SearchFieldMapView().then {
        $0.autocorrectionType = .no
        $0.placeholder = "Что будем искать?"
        $0.setLeftImage(image: .appImage(.searchIcon).withTintColor(.appColor(.grayEmpty)))
        $0.isHidden = true
    }
    
    let mapView = UIImageView(image: .appImage(.content1)).then {
        $0.contentMode = .scaleAspectFill
        $0.isUserInteractionEnabled = true
    }
    
    let callToActionButton = MapButton(rightIcon: .appImage(.richArrow)).then {
        $0.setTitle("Кто рядом", for: .normal)
    }
    
    let mapPositionButton = UIButton(type: .system).then {
        $0.setImage(.appImage(.mapPositionButton), for: .normal)
    }
    
    let collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: SnapCenterLayout().then {
        $0.itemSize = CGSize(width: UIScreen.main.bounds.width - 16 * 2, height: 200)
        $0.minimumLineSpacing = 8
        $0.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
        $0.scrollDirection = .horizontal
    }).then {
        $0.backgroundColor = .clear
        $0.isPagingEnabled = false
        $0.decelerationRate = .fast
        $0.showsHorizontalScrollIndicator = false
        $0.isHidden = true
    }
    
    var resultTableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.rowHeight = 60
        $0.isHidden = true
        $0.hero.modifiers = [.cascade]
    }
    
    var currentState: MapViewController.State = .normal {
        didSet {
            if oldValue == currentState { return }
            switch currentState {
            case .search:
                self.searchButton.isHidden = true
                self.searchField.isHidden = false
                
                self.searchField.transform = .init(translationX: 0, y: -200)
                UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: []) {
                    self.searchField.transform = .identity
                } completion: { _ in
                    let _ = self.searchField.becomeFirstResponder()
                }
                
                if oldValue == .showDogs {
                    setCollectionView(show: false)
                }
                
                resultTableView.isHidden = false
                resultTableView.reloadData()
            case .normal:
                if searchButton.isHidden == true {
                    self.searchButton.isHidden = false
                    
                    self.searchButton.transform = .init(translationX: 0, y: -200)
                    self.searchField.transform = .identity
                    UIView.animate(withDuration: 0.3, delay: 0.0, options: []) {
                        self.searchField.transform = .init(translationX: 0, y: -200)
                        self.searchButton.transform = .identity
                    } completion: { _ in
                        self.searchField.isHidden = true
                    }
                }
                
                if oldValue == .showDogs {
                    setCollectionView(show: false)
                }
                
                resultTableView.isHidden = true
            case .showDogs:
                if oldValue == .search {
                    self.searchButton.isHidden = false
                    
                    self.searchButton.transform = .init(translationX: 0, y: -200)
                    self.searchField.transform = .identity
                    UIView.animate(withDuration: 0.3, delay: 0.0, options: []) {
                        self.searchField.transform = .init(translationX: 0, y: -200)
                        self.searchButton.transform = .identity
                    } completion: { _ in
                        self.searchField.isHidden = true
                    }
                }
                
                setCollectionView(show: true)
                resultTableView.isHidden = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                    self?.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: true)
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [weak self] in
                    self?.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: true)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBindings()
        
        searchField.delegate = self
        searchButton.addTarget(self, action: #selector(setStateSearch), for: .touchUpInside)
        
        collectionView.register(DogProfileCollectionViewCell.self,
                                forCellWithReuseIdentifier: DogProfileCollectionViewCell.reusableID)
        
        collectionView.dataSource = self
        
        DispatchQueue.main.async {
            self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: false)
        }
        
        currentState = {currentState}()
        
        callToActionButton.addTarget(self, action: #selector(callToAction), for: .touchUpInside)
        
        resultTableView.register(ResultTableViewCell.self, forCellReuseIdentifier: "cell")
        resultTableView.dataSource = self
        resultTableView.delegate = self
        
        self.hero.isEnabled = true
    }
    
    func setupBindings() {
        searchField.textPublisher
            .sink(receiveValue: { value in
                self.searchResultCount = value?.count ?? 0
                self.resultTableView.reloadData()
            })
            .store(in: &subscriptions)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//            self.showInisibleZoneConfigurator()
//        }
        
        //showProfile()
        //showMyProfile()
        //showInisibleZoneConfigurator()
    }
    
    func setupUI() {
        self.view.backgroundColor = .appColor(.backgroundFirst)
        
        [mapView, searchField, searchButton, collectionView, resultTableView].forEach({ self.view.addSubview($0) })
        
        [callToActionButton, mapPositionButton].forEach({mapView.addSubview($0)})
        
        searchField.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide).inset(16)
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(24)
        }
        
        searchButton.snp.makeConstraints { make in
            make.left.equalTo(self.view.safeAreaLayoutGuide).inset(16)
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(24)
        }
        
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.bottom.left.right.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(216)
        }
        
        callToActionButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            bottomCallToActionButton = make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16).constraint
        }
        
        mapPositionButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            bottomMapPositionButton = make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16).constraint
        }
        
        resultTableView.snp.makeConstraints { make in
            make.top.equalTo(searchField.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
    }
    
    
    @objc func callToAction() {
        currentState = (currentState == .showDogs) ? .normal : .showDogs
    }
    
    func showMyProfile() {
        let presentedVC = ProfileEditViewController()
        presentedVC.modalPresentationStyle = .popover
        
        
        present(presentedVC, animated: true)
    }
    
    func showProfile() {
        let presentedVC = ProfileSmallViewController()
        presentedVC.modalPresentationStyle = .popover
        
        presentedVC.mapView = view
        
        present(presentedVC, animated: true)
    }
    
    func setCollectionView(show: Bool) {
        self.collectionView.transform = show ? .init(translationX: 0, y: 240) : .identity
        self.collectionView.isHidden = false
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: []) {
            self.collectionView.transform = show ? .identity : .init(translationX: 0, y: 240)
            self.bottomMapPositionButton.update(inset: show ? 236 : 16)
            self.bottomCallToActionButton.update(inset: show ? 236 : 16)
            self.mapView.layoutSubviews()
        } completion: { _ in
            self.collectionView.isHidden = show ? false : true
        }
    }
    
    func showInisibleZoneConfigurator() {
        let presentedVC = InvisibleZoneConfigurateViewController()

        present(presentedVC, animated: false)
        
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//            presentedVC.dismiss(animated: true, completion: nil)
//        }
    }
    
    @objc func setStateSearch() {
        self.currentState = .search
    }
    
    
    deinit {
        print("map deinit")
    }
}


extension MapViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(false)
        
        currentState = .normal
        return true
    }
}


extension MapViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DogProfileCollectionViewCell.reusableID, for: indexPath) as! DogProfileCollectionViewCell
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
}


extension MapViewController: DogProfileCollectionViewCellDelegate {
    func profileAction() {
        self.showProfile()
    }
    
    func friendAction() {
        
    }
    
    
}


extension MapViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentState == .search ? searchResultCount : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ResultTableViewCell
        return cell
    }
}



extension MapViewController: UITableViewDelegate {
    
}
