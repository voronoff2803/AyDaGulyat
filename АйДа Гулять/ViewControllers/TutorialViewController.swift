//
//  TutorialViewController.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 19.10.2022.
//

import UIKit

class TutorialViewController: UIViewController {
    let closeButton = UIButton().then {
        $0.setImage(.appImage(.close), for: .normal)
        $0.tintColor = .appColor(.grayEmpty)
    }
    
    let closeLabel = UILabel().then {
        $0.font = .montserratRegular(size: 16)
        $0.textColor = .appColor(.grayEmpty)
        $0.text = "Смотреть позже в “Меню”"
    }
    
    let pageControl = UIPageControl().then {
        $0.pageIndicatorTintColor = .appColor(.grayEmpty)
        $0.currentPageIndicatorTintColor = .appColor(.black)
        $0.isUserInteractionEnabled = false
    }
    
    let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    lazy var pageView: UIView! = {
        self.pageViewController.view
    }()
    
    var currentIndex = 0 {
        didSet {
            pageControl.currentPage = currentIndex
        }
    }
    
    let tutorialModels: [TutorialContentModel] = [TutorialContentModel(labelText: "Нажми на любой значок, **увидишь фото собаки**. Нажми еще раз и **перейдешь в профиль** хозяина", imageName: "content1"),
                                                  TutorialContentModel(labelText: "Тест", imageName: "content1"),
                                                  TutorialContentModel(labelText: "Тест22332423", imageName: "content1")]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageViewController.dataSource = self
        pageViewController.delegate = self
        pageViewController.setViewControllers([self.viewControllerForIndex(index: 0)!], direction: .forward, animated: true)
        
        addChild(pageViewController)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(nextPage))
        pageView.addGestureRecognizer(tapGesture)
        
        setupUI()
    }
    
    func setupUI() {
        self.view.backgroundColor = .appColor(.backgroundFirst)
        
        [pageView, closeButton, closeLabel, pageControl].forEach({self.view.addSubview($0)})
        
        closeButton.snp.makeConstraints { make in
            make.right.top.equalTo(self.view.safeAreaLayoutGuide).inset(28)
        }
        
        closeLabel.snp.makeConstraints { make in
            make.right.equalTo(closeButton.snp.left).offset(-16)
            make.centerY.equalTo(closeButton)
        }
        
        pageView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(closeLabel.snp.bottom).offset(30)
            make.bottom.equalTo(pageControl.snp.top).offset(-40)
        }
        
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(pageView.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(28)
            make.height.equalTo(10)
        }
        
        pageControl.numberOfPages = self.tutorialModels.count
        pageControl.currentPage = 0
    }
    
    @objc func nextPage() {
        guard let currentViewController = pageViewController.viewControllers?.first else { return print("Failed to get current view controller") }
        guard let nextViewController = pageViewController.dataSource?.pageViewController( pageViewController, viewControllerAfter: currentViewController) else { return }
        
        pageViewController.setViewControllers([nextViewController], direction: .forward, animated: true, completion: { completed in
            guard completed, let contentViewController = nextViewController as? TutorialPageContentViewController else { return }
            
            self.currentIndex = contentViewController.index
        })
    }
}


extension TutorialViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! TutorialPageContentViewController).index
        index -= 1
        
        return self.viewControllerForIndex(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! TutorialPageContentViewController).index
        index += 1
        
        return self.viewControllerForIndex(index: index)
    }
    
    func viewControllerForIndex(index: Int) -> UIViewController? {
        if index < 0 || index >= tutorialModels.count {
            return nil
        }
        
        let tutorialPageContentViewController = TutorialPageContentViewController()
        tutorialPageContentViewController.tutorialContentModel = tutorialModels[index]
        tutorialPageContentViewController.index = index
        
        return tutorialPageContentViewController
    }
}


extension TutorialViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed, let contentViewController = pageViewController.viewControllers?.first as? TutorialPageContentViewController else { return }
        
        currentIndex = contentViewController.index
    }
}
