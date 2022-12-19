//
//  PersonProfileViewController.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 24.10.2022.
//

import UIKit


class PersonEditViewController: AppRootViewController, TextFieldNextable {
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
    
    let tagListView = TagListView().then {
        $0.marginX = 10
        $0.marginY = 10
        $0.paddingX = 14
        $0.paddingY = 14
        $0.textFont = .montserratRegular(size: 14)
        $0.cornerRadius = 4
        $0.borderWidth = 1
        $0.borderColor = .appColor(.lightGray)
        $0.tagBackgroundColor = .appColor(.lightGray).withAlphaComponent(0.3)
        $0.textColor = .appColor(.black)
    }
    
    let genderControl = DefaultSegmentedPicker(titleText: "Пол")
    
    let dataPicker = DefaultDatePicker(titleText: "День рождения")
    
    let privacyPicker = DefaultPicker(titleText: "Конфедициальность", isManySelectable: true)
    
    let hobbiesPicker = DefaultPicker(titleText: "Увлечения")
    
    let addTextField = NextGrowingTextView().then {
        $0.configuration = .init(minLines: 6,
                                 maxLines: 6,
                                 isAutomaticScrollToBottomEnabled: true,
                                 isFlashScrollIndicatorsEnabled: true)
        $0.placeholderLabel.text = "Расскажите о себе"
        $0.textView.font = UIFont.montserratRegular(size: 16)
    }
    
    let saveButton = DefaultButton(style: .filled).then {
        $0.setTitle("Сохранить", for: .normal)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        privacyPicker.setupValues(values: ["Аффенпинчер", "Бишон фризе", "Бордер-терьер", "Бостон-терьер", "Брюссельский грифон", "Вельштерьер", "Джек-рассел-терьер", "Йоркширский терьер"])
        
        tagListView.addTags(["🏃‍♂️  Бег с собакой", "🎨  Рисование", "📘  Чтение книг", "💩  Политика"])

        setupUI()
        
        genderControl.setupValues(values: ["Мальчик", "Девочка"], selectedIndex: 0)
        scrollView.delegate = self
        addTextField.textView.delegate = self
    }
    

    func setupUI() {
        self.view.backgroundColor = .appColor(.backgroundFirst)
        
        [nameTextField, surnameTextField, genderControl, dataPicker, privacyPicker, hobbiesPicker, tagListView, addTextField, saveButton].forEach({stackFormView.addArrangedSubview($0)})
        
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


extension PersonEditViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}


extension PersonEditViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
