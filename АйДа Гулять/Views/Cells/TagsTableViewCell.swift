//
//  TagsTableViewCell.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 04.11.2022.
//


import UIKit

class TagsTableViewCell: UITableViewCell {
    static let reusableID = "tagsCell"
    
    var tableViewWidth: CGFloat = 0
    
    let titleLabel = UILabel().then {
        $0.text = "Увлечения"
        $0.font = .montserratRegular(size: 16)
        $0.textColor = .appColor(.grayEmpty)
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        tagListView.frame = CGRect(origin: .zero, size: CGSize(width: tableViewWidth - 28 * 2, height: 0))
        tagListView.layoutSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
        
    func setupUI() {
        self.backgroundColor = .appColor(.backgroundFirst)
        
        selectionStyle = .none
        
        [titleLabel, tagListView].forEach({self.contentView.addSubview($0)})
        tagListView.addTags(["🏃‍♂️  Бег с собакой", "🎨  Рисование", "📘  Чтение книг", "💩  Политика"])
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.left.equalToSuperview().inset(28)
        }
        
        tagListView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(28)
            make.bottom.equalToSuperview().inset(20)
            //make.top.equalToSuperview().priority(.high)
        }
    }
}
