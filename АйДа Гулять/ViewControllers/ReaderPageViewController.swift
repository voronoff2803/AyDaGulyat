//
//  ReaderPageViewController.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 27.12.2022.
//

import UIKit


class ReaderPageViewController: UIViewController {
    //let viewModel: WalkViewModel
    let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    lazy var pageView: UIView! = {
        self.pageViewController.view
    }()
    
    let nextLeftButton = UIButton(type: .system).then {
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: -30, bottom: 0, right: 0)
        $0.tintColor = .appColor(.black)
        $0.setImage(.appImage(.longArrowLeft), for: .normal)
    }
    
    let nextRightButton = UIButton(type: .system).then {
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -30)
        $0.tintColor = .appColor(.black)
        $0.setImage(.appImage(.longArrowRight), for: .normal)
    }
    
    let currentArticle = Label().then {
        $0.textColor = .appColor(.black)
        $0.text = "2"
        $0.font = .montserratRegular(size: 14)
        $0.numberOfLines = 1
        $0.textAlignment = .center
    }
    
    let allArticle = Label().then {
        $0.textColor = .appColor(.grayEmpty)
        $0.text = " / 140"
        $0.font = .montserratRegular(size: 12)
        $0.numberOfLines = 1
        $0.textAlignment = .center
    }
    
    var shadowView = UIView().then {
        $0.layer.shadowColor = UIColor.darkGray.cgColor
        $0.layer.shadowOffset = CGSize(width: 10.0, height: 10.0)
        $0.layer.shadowOpacity = 0.2
        $0.layer.shadowRadius = 16
    }
    
    lazy var pageControl = UIStackView(arrangedSubviews: [nextLeftButton, currentArticle, allArticle, nextRightButton]).then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 24
    }
    
    init() {
        //self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .appColor(.backgroundFirst)
        setupUI()

        addChild(pageViewController)
        
//        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        pageViewController.setViewControllers([ReaderViewController()], direction: .forward, animated: false)
        
        title = "Уход за шерстью собаки"
        
        nextLeftButton.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
        nextRightButton.addTarget(self, action: #selector(previousPage), for: .touchUpInside)
    }
    

    func setupUI() {
        [pageView, shadowView].forEach({self.view.addSubview($0)})
        
        shadowView.addSubview(pageControl)
        
        pageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        shadowView.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.horizontalEdges.equalToSuperview().inset(28)
        }
        
        nextLeftButton.snp.makeConstraints { make in
            make.width.equalTo(nextRightButton.snp.width)
        }
        
        pageControl.snp.makeConstraints { make in
            make.edges.equalTo(shadowView)
        }
    }
    
    @objc func nextPage() {
        pageViewController.setViewControllers([ReaderViewController()], direction: .reverse, animated: true)
    }
    
    @objc func previousPage() {
        pageViewController.setViewControllers([ReaderViewController()], direction: .forward, animated: true)
    }
}



extension ReaderPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        return ReaderViewController()
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return ReaderViewController()
    }
}


//extension ReaderPageViewController: UIPageViewControllerDelegate {
//    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
//        guard completed, let contentViewController = pageViewController.viewControllers?.first else { return }
//
//        if contentViewController is DogProfileViewController {
//            self.state = .dogProfile
//        } else {
//            self.state = .personProfile
//        }
//    }
//}
