//
//  MapViewController.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 23.10.2022.
//

import UIKit
import Jelly
import SnapKit

class MapViewController: UIViewController {
    enum State {
        case search
        case normal
    }
    
    let testButton = DefaultButton(style: .filled)
    let searchButton = UIButton(type: .system).then {
        $0.setImage(.appImage(.searchButton), for: .normal)
    }
    
    let searchField = SearchFieldMapView().then {
        $0.autocorrectionType = .no
        $0.placeholder = "Что будем искать?"
        $0.setLeftImage(image: .appImage(.searchIcon).withTintColor(.appColor(.grayEmpty)))
    }
    
    var currentState: MapViewController.State = .normal {
        didSet {
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

            case .normal:
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
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        searchField.delegate = self
        searchButton.addTarget(self, action: #selector(setStateSearch), for: .touchUpInside)
        
        currentState = {currentState}()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.showInisibleZoneConfigurator()
        }
    }
    
    func setupUI() {
        self.view.backgroundColor = .appColor(.backgroundFirst)
        
        [searchField, testButton, searchButton].forEach({ self.view.addSubview($0) })
        
        testButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        searchField.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide).inset(16)
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(24)
        }
        
        searchButton.snp.makeConstraints { make in
            make.left.equalTo(self.view.safeAreaLayoutGuide).inset(16)
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(24)
        }
    }
    
    func showProfile() {
        let presentedVC = ProfileViewController()
        presentedVC.modalPresentationStyle = .popover
        
        
        present(presentedVC, animated: true)
    }
    
    func showInisibleZoneConfigurator() {
        let presentedVC = InvisibleZoneConfigurateViewController()
        
        //present(presentedVC, animated: false)
        
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//            presentedVC.dismiss(animated: true, completion: nil)
//        }
    }
    
    @objc func setStateSearch() {
        self.currentState = .search
    }
}


extension MapViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(false)
        
        currentState = .normal
        return true
    }
}
