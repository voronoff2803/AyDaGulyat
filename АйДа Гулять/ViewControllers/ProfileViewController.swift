//
//  ProfileViewController.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 22.10.2022.
//

import UIKit


class ProfileViewController: UIViewController {
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
    
    let dogsCollectionView = UICollectionView(frame: .zero,
                                                 collectionViewLayout:
                                                    PagingCollectionViewLayout().then {
                                                        $0.scrollDirection = .horizontal
                                                        $0.itemSize = .init(width: 110, height: 110)
                                                        $0.minimumLineSpacing = 15
                                                        $0.sectionInset = .init(top: 0, left: 50, bottom: 0, right: 50)
    }).then {
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        $0.decelerationRate = .fast
        $0.clipsToBounds = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dogsCollectionView.register(DogAvatarCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        dogsCollectionView.dataSource = self
        dogsCollectionView.delegate = self
        dogsCollectionView.reloadData()
        
        pageControlView.addTarget(self, action: #selector(pageControlHandle), for: .valueChanged)
        
        self.dogs = [.empty]
    
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.dogsCollectionView.scrollToItem(at: IndexPath(row: 1, section: 0), at: .centeredHorizontally, animated: false)
        self.updateCellsLayout()
    }
    
    @objc private func pageControlHandle(sender: UIPageControl){
        dogsCollectionView.scrollToItem(at: IndexPath(row: sender.currentPage + 1, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    func updateCellsLayout()  {
        let centerX = dogsCollectionView.contentOffset.x + (dogsCollectionView.frame.size.width)/2
        for cell in dogsCollectionView.visibleCells {
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
                    pageControlView.currentPage = indexPath.row - 1
                }
            }
        }
    }
    
    
    func setupUI() {
        self.view.addSubview(contentView)
        
        [dogsCollectionView, pageControlView].forEach({self.view.addSubview($0)})
        
        self.view.backgroundColor = .init(white: 0.9, alpha: 1.0)
        
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
            make.top.equalTo(dogsCollectionView.snp.bottom).offset(30)
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
        } else {
            if (collectionView.cellForItem(at: indexPath)?.frame.width ?? 0) > 80 {
                dogs[indexPath.row - 1] = .normal(.appImage(.content2))
                if let cell = collectionView.cellForItem(at: indexPath) as? DogAvatarCollectionViewCell {
                    cell.setup(model: dogs[indexPath.row - 1])
                }
            }
        }
        
        self.dogsCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        //pageControlView.currentPage = indexPath.row - 1
    }
}
