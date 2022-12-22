//
//  AgreementViewController.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 24.10.2022.
//

import UIKit
import Combine
import MarkdownView

class AgreementViewController: AppRootViewController {
    private var subscriptions = Set<AnyCancellable>()
    
    let coordinator: Coordinator
    
    private let activityIndicator = ActivityIndicator()
    private let errorIndicator = ErrorIndicator()
    
    var loadingPublisher: AnyPublisher<Bool, Never> {
        activityIndicator.loading.eraseToAnyPublisher()
    }
    
    var errorPublisher: AnyPublisher<Error, Never> {
        errorIndicator.errors.eraseToAnyPublisher()
    }
    
    let textView = MarkdownView().then {
        $0.backgroundColor = .clear
    }
    
    var exitButton = UIButton(type: .system).then {
        $0.setImage(.appImage(.close), for: .normal)
        $0.tintColor = .appColor(.grayEmpty)
    }
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        exitButton.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)

        setupUI()
        
        APIService.shared.getPageByAlias(alias: "tos")
            .trackError(errorIndicator)
            .trackActivity(activityIndicator)
            .compactMap { data in
                data.pageByAlias?.valueRu
            }
            .sink(receiveValue: { res in
                self.textView.load(markdown: res)
            })
            .store(in: &subscriptions)
            
    }
    
    func setupBindings() {
        self.loadingPublisher
            .sink { [weak self] isLoading in
                //self?.loginButton.isLoading = isLoading
            }
            .store(in: &subscriptions)
        self.errorPublisher
            .sink { [weak self] error in
                self?.showError(error: error)
            }
            .store(in: &subscriptions)
    }
    
    
    func setupUI() {
        self.view.backgroundColor = .appColor(.backgroundFirst)
        
        [textView, exitButton].forEach({ self.view.addSubview($0) })
        
        exitButton.snp.makeConstraints { make in
            make.right.top.equalTo(self.view.safeAreaLayoutGuide).inset(28)
            make.height.equalTo(28)
        }
        
        textView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide).inset(28)
            make.top.equalTo(exitButton.snp.bottom).offset(10)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    
    @objc func dismissAction() {
        coordinator.route(context: self, to: .back, parameters: nil)
    }
}
