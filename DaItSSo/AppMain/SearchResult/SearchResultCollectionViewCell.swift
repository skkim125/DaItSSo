//
//  SearchResultCollectionViewCell.swift
//  DaItSSo
//
//  Created by 김상규 on 6/14/24.
//

import UIKit
import Kingfisher
import SnapKit

class SearchResultCollectionViewCell: UICollectionViewCell {
    let shoppingImg = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.layer.cornerRadius = 12
        imgView.clipsToBounds = true
        imgView.layer.borderWidth = 0.5
        imgView.layer.borderColor = UIColor.appLightGray.cgColor
        
        return imgView
    }()
    
    let shoppingMallNameLabel = {
        let label = UILabel()
        label.textColor = .appGray
        label.font = .systemFont(ofSize: 13)
        
        return label
    }()
    
    let shoppingTitleLabel = {
        let label = UILabel()
        label.textColor = .appBlack
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.numberOfLines = 0
        
        return label
    }()
    
    let shoppingPriceLabel = {
        let label = UILabel()
        label.textColor = .appBlack
        label.font = .systemFont(ofSize: 16, weight: .heavy)
        
        return label
    }()
    
    lazy var selectProductButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "handbag.fill"), for: .normal)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(selectProductButtonClicked), for: .touchUpInside)
        
        return button
    }()
    
    var myShopping = Item(title: "", image: "", mallName: "", lprice: "", link: "", productId: "")
    var item: Item?
    var isAdd: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() {
        // MARK: addSubView()
        contentView.addSubview(shoppingImg)
        contentView.addSubview(shoppingMallNameLabel)
        contentView.addSubview(shoppingTitleLabel)
        contentView.addSubview(shoppingPriceLabel)
        contentView.addSubview(selectProductButton)
    }
    
    func configureLayout() {
        shoppingImg.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
            make.height.equalTo(contentView.snp.width).multipliedBy(1.2)
        }
        
        selectProductButton.snp.makeConstraints { make in
            make.bottom.equalTo(shoppingImg.snp.bottom).inset(10)
            make.trailing.equalTo(shoppingImg.snp.trailing).inset(10)
            make.size.equalTo(30)
        }
        
        shoppingMallNameLabel.snp.makeConstraints { make in
            make.top.equalTo(shoppingImg.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(shoppingImg)
            make.height.equalTo(15)
        }
        
        shoppingTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(shoppingMallNameLabel.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(shoppingMallNameLabel)
            make.height.lessThanOrEqualTo(40)
        }
        
        shoppingPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(shoppingTitleLabel.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(shoppingTitleLabel)
            make.bottom.greaterThanOrEqualTo(contentView.safeAreaLayoutGuide).inset(10)
        }
    }
    
    func configureCellUI(item: Item) {
        let url = URL(string: item.image)
        shoppingImg.kf.setImage(with: url)
        shoppingMallNameLabel.text = item.mallName
        shoppingTitleLabel.text = String.removeTag(title: item.title)
        shoppingPriceLabel.text = "\(String.formatInt(int: item.lprice))원"
    }
    
    func configureSelectButtonUI() {
        if isAdd {
            selectProductButton.backgroundColor = .appWhite
            selectProductButton.imageView?.tintColor = .appBlack
        } else {
            selectProductButton.backgroundColor = .appBlack.withAlphaComponent(0.3)
            selectProductButton.imageView?.tintColor = .white
        }
    }
    
    @objc private func selectProductButtonClicked() {
        isAdd.toggle()
        if let i = item {
            if UserDefaultsManager.shared.myShopping.isEmpty {
                let filterdShopping = UserDefaultsManager.shared.myShopping.filter { $0.productId == i.productId }
                if isAdd {
                    UserDefaultsManager.shared.myShopping.append(i)
                } else {
                    UserDefaultsManager.shared.myShopping.remove(at: UserDefaultsManager.shared.myShopping.lastIndex(where: {
                        $0.productId == filterdShopping[filterdShopping.startIndex].productId
                    })!)
                }
            } else {
                if isAdd {
                    UserDefaultsManager.shared.myShopping.append(i)
                } else {
                    UserDefaultsManager.shared.myShopping.remove(at: UserDefaultsManager.shared.myShopping.lastIndex(where: {
                        $0.productId == i.productId
                    })!)
                }
            }
        }
        
        configureSelectButtonUI()
    }
}

extension String {
    static func removeTag(title: String) -> String {
        var removeTag = title.replacingOccurrences(of: "<b>", with: "")
        removeTag = removeTag.replacingOccurrences(of: "</b>", with: "")
        
        return removeTag
    }
}
