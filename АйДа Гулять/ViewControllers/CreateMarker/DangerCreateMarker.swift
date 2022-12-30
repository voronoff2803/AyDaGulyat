//
//  DangerCreateMarker.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 29.12.2022.
//

import UIKit
import Combine


class DangerCreateMarker: AppRootViewController, TextFieldNextable {
    private var subscriptions = Set<AnyCancellable>()
    
    let viewModel: CreateMarkerViewModel
    
    let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
    }
    
    let stackFormView = UIStackView().then {
        $0.layoutMargins = UIEdgeInsets(top: 0, left: 28, bottom: 0, right: 28)
        $0.isLayoutMarginsRelativeArrangement = true
        $0.axis = .vertical
        $0.spacing = 20
        $0.distribution = .fill
    }
    
    let collectionLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.itemSize = CGSize(width: 128, height: 128)
        //$0.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    }
    
    lazy var photoCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout).then {
        $0.backgroundColor = .clear
    }
    
    let privacyPicker = DefaultPicker(titleText: "Тип опасности", isManySelectable: false)
    
    
    let addTextField = NextGrowingTextView().then {
        $0.configuration = .init(minLines: 6,
                                 maxLines: 6,
                                 isAutomaticScrollToBottomEnabled: true,
                                 isFlashScrollIndicatorsEnabled: true)
        $0.placeholderLabel.text = "Комментарий"
        $0.textView.font = UIFont.montserratRegular(size: 16)
    }
    
    let saveButton = DefaultButton(style: .filled).then {
        $0.setTitle("Опубликовать", for: .normal)
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
        
        privacyPicker.setupValues(values: ["Другая опасность", "Прятать дату рождения"])

        setupUI()
        setupBindings()
        
        scrollView.delegate = self
        addTextField.textView.delegate = self
        
        photoCollectionView.dataSource = viewModel
        photoCollectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "cell")
        photoCollectionView.register(AddPhotoCell.self, forCellWithReuseIdentifier: "add")
    }
    

    func setupUI() {
        self.view.backgroundColor = .appColor(.backgroundFirst)
        
        [privacyPicker, photoCollectionView, addTextField, saveButton].forEach({stackFormView.addArrangedSubview($0)})
        
        [stackFormView].forEach({self.scrollView.addSubview($0)})
        [scrollView].forEach({self.view.addSubview($0)})
        
        photoCollectionView.snp.makeConstraints { make in
            make.height.equalTo(150)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide)
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
    
    func setupBindings() {
        
    }
}


extension DangerCreateMarker: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}


extension DangerCreateMarker: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
