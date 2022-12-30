//
//  CreateMarkerPanel.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 28.12.2022.
//

import UIKit

class CreateMarkerPanel: AppRootViewController, TextFieldNextable, ScrollViewProvider {
    var provideScrollView: UIScrollView? {
        return pageViewController.viewControllers?.first?.view.childScrollView
    }
    
    enum State {
        case danger
        case lost
        case found
    }
    
    let viewModel: CreateMarkerViewModel
    
    var state: CreateMarkerPanel.State = .danger {
        didSet {
            switch state {
            case .danger:
                break
            case .lost:
                break
            case .found:
                break
            }
        }
    }
    
    let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    lazy var pageView: UIView! = {
        self.pageViewController.view
    }()
    
    let titleLabel = Label().then {
        $0.text = "Добавление метки"
        $0.font = .montserratRegular(size: 20)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    let segmentedSelector = CustomSegmentedControl(frame: .zero, buttonTitle: ["Опасность", "Потерял", "Нашёл"])
    
    
    let continueButton = DefaultButton().then {
        $0.setTitle("Да, завершить", for: .normal)
    }
    
    let cancelButton = DefaultButton(style: .bordered).then {
        $0.setTitle("Нет, хочу погулять еще", for: .normal)
    }
    
    init(viewModel: CreateMarkerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .appColor(.backgroundFirst)
        setupUI()
        
        segmentedSelector.delegate = self
        
        addChild(pageViewController)
        
        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        pageViewController.setViewControllers([DangerCreateMarker(viewModel: viewModel)], direction: .forward, animated: false)
    }
    

    func setupUI() {
        
        [titleLabel, pageView, segmentedSelector].forEach({self.view.addSubview($0)})
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(30)
            make.centerX.equalToSuperview()
        }
        
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        segmentedSelector.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(28)
            make.height.equalTo(40)
        }
        
        pageView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(segmentedSelector.snp.bottom)
            make.bottom.equalTo(view.safeAreaLayoutGuide).priority(.low)
        }
        
        pageView.tag = 22
        keyboardAvoidView = pageView

        
//        continueButton.snp.makeConstraints { make in
//            make.top.equalTo(infoStackView.snp.bottom).offset(20)
//            make.horizontalEdges.equalToSuperview().inset(28)
//        }
//
//        cancelButton.snp.makeConstraints { make in
//            make.top.equalTo(continueButton.snp.bottom).offset(15)
//            make.horizontalEdges.equalToSuperview().inset(28)
//            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
//        }
    }
}


extension CreateMarkerPanel: CustomSegmentedControlDelegate {
    func change(to index: Int) {
        switch index {
        case 0:
            state = .danger
        case 1:
            state = .found
        case 2:
            state = .lost
        default:
            break
        }
    }
}


extension CreateMarkerPanel: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    
}
