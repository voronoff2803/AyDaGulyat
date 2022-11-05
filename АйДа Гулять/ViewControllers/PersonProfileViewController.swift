//
//  PersonProfileViewController.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 24.10.2022.
//

import UIKit



class PersonProfileViewController: AppRootViewController, TextFieldNextable {
    let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
    }
    
    let stackFormView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 20
        $0.distribution = .fill
    }
    
    let nameTextField = DefaultTextField().then {
        $0.placeholder = "Имя"
        $0.autocorrectionType = .no
        $0.autocapitalizationType = .sentences
    }
    
    let surnameTextField = DefaultTextField().then {
        $0.placeholder = "Фамилия"
        $0.autocorrectionType = .no
        $0.autocapitalizationType = .sentences
    }
    
    let genderControl = DefaultSegmentedPicker(titleText: "Пол")
    
    let dataPicker = DefaultDatePicker(titleText: "День рождения")
    
    let dogTypePicker = DefaultPicker(titleText: "Порода")
    
    let dogColorPicker = DefaultPicker(titleText: "Окрас")
    
    let addTextField = DefaultTextField().then {
        $0.placeholder = "Дополнительно"
        $0.autocorrectionType = .no
        $0.autocapitalizationType = .sentences
    }
    
    let saveButton = DefaultButton(style: .filled).then {
        $0.setTitle("Сохранить", for: .normal)
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        dogTypePicker.setupValues(values: ["Аффенпинчер", "Бишон фризе", "Бордер-терьер", "Бостон-терьер", "Брюссельский грифон", "Вельштерьер", "Джек-рассел-терьер", "Йоркширский терьер"], selectedIndex: 2)
        
        dogColorPicker.setupValues(values: ["Лиловый", "Рыжий", "Палевый", "Осветлённый коричневый", "Красный", "Вельштерьер", "Жёлтый", "Осветлённый рыжий"], selectedIndex: 2)
        
        genderControl.setupValues(values: ["Мальчик", "Девочка"], selectedIndex: 0)
    }
    

    func setupUI() {
        self.view.backgroundColor = .appColor(.backgroundFirst)
        
        [nameTextField, surnameTextField, genderControl, dataPicker, dogTypePicker, dogColorPicker, addTextField, saveButton].forEach({stackFormView.addArrangedSubview($0)})
        
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
        
//        dogTypePicker.snp.makeConstraints { make in
//            make.height.equalTo(55.0)
//        }
    }
}
