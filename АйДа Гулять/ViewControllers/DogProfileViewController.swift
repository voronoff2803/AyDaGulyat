//
//  DogProfileViewController.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 23.10.2022.
//

import UIKit

class DogProfileViewController: AppRootViewController, TextFieldNextable {
    let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
    }
    
    let stackFormView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 20
    }
    
    let nameTextField = DefaultTextField().then {
        $0.placeholder = "Кличка"
        $0.autocorrectionType = .no
        $0.autocapitalizationType = .sentences
    }
    
    let name2TextField = DefaultTextField().then {
        $0.placeholder = "Кличка"
        $0.autocorrectionType = .no
        $0.autocapitalizationType = .sentences
    }
    
    let name3TextField = DefaultTextField().then {
        $0.placeholder = "Кличка"
        $0.autocorrectionType = .no
        $0.autocapitalizationType = .sentences
    }
    
    let genderControl = UISegmentedControl().then {
        $0.insertSegment(withTitle: "Девочка", at: 0, animated: false)
        $0.insertSegment(withTitle: "Мальчик", at: 0, animated: false)
        $0.selectedSegmentIndex = 0
    }
    
    let dataPicker = UIDatePicker()
    
    let dogTypePicker = UIPickerView()
    
    let saveButton = DefaultButton(style: .filled).then {
        $0.setTitle("Сохранить", for: .normal)
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    

    func setupUI() {
        self.view.backgroundColor = .appColor(.backgroundFirst)
        
        [nameTextField, genderControl, name2TextField, dataPicker, dogTypePicker, name3TextField, saveButton].forEach({stackFormView.addArrangedSubview($0)})
        
        [stackFormView].forEach({self.scrollView.addSubview($0)})
        [scrollView].forEach({self.view.addSubview($0)})
        
        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide).inset(28)
            make.bottom.equalToSuperview()
        }
        
        stackFormView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(scrollView.contentLayoutGuide)
            make.verticalEdges.equalTo(scrollView.contentLayoutGuide).inset(28)
            make.width.equalTo(scrollView)
        }
    }
}
