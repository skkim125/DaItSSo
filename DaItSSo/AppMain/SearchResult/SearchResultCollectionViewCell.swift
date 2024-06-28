//
//  SearchResultCollectionViewCell.swift
//  DaItSSo
//
//  Created by 김상규 on 6/14/24.
//

import UIKit
import Kingfisher
import SnapKit

class SearchResultCollectionViewCell: BaseCollectionViewCell {
    let shoppingImg = {
        let imgView = UIImageView()
        imgView.image = UIImage(systemName: "arrow.clockwise")
        imgView.contentMode = .scaleAspectFit
        imgView.backgroundColor = .appLightGray
        imgView.tintColor = .appDarkGray
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
        var configuration = UIButton.Configuration.bordered()
        configuration.image = UIImage(systemName: "handbag.fill")
        configuration.image?.withTintColor(.appBlack)
        configuration.background.strokeColor = .appLightGray
        configuration.background.strokeWidth = 0.3
        button.configuration = configuration
        
        button.addTarget(self, action: #selector(selectProductButtonClicked), for: .touchUpInside)
        
        return button
    }()
    
    private let userDefaults = UserDefaultsManager.shared
    var item: Item?
    var isAdd: Bool = false

    override func configureHierarchy() {
        contentView.addSubview(shoppingImg)
        contentView.addSubview(shoppingMallNameLabel)
        contentView.addSubview(shoppingTitleLabel)
        contentView.addSubview(shoppingPriceLabel)
        contentView.addSubview(selectProductButton)
    }
    
    override func configureLayout() {
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
        guard let url = URL(string: item.image) else { return }
        
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                let data = try Data(contentsOf: url)
                
                DispatchQueue.main.async {
                    self.shoppingImg.image = UIImage(data: data)
                    self.shoppingImg.contentMode = .scaleAspectFill
                }
            } catch {
                DispatchQueue.main.async {
                    self.shoppingImg.image = UIImage(systemName: "xmark")
                }
            }
        }
        shoppingMallNameLabel.text = item.mallName
        shoppingTitleLabel.text = String.removeTag(title: item.title)
        shoppingPriceLabel.text = String.formatInt(int: item.lprice) + "원"
    }
    
    func configureSelectButtonUI() {
        selectProductButton.configuration?.background.backgroundColor = isAdd ? .appWhite : .appBlack.withAlphaComponent(0.3)
        selectProductButton.configuration?.baseForegroundColor = isAdd ? .appBlack : .appWhite
    }
    
    @objc private func selectProductButtonClicked() {
        isAdd.toggle()
        if let i = item {
            
            if isAdd {
                userDefaults.myShopping.append(i)
            } else {
                switch userDefaults.myShopping.isEmpty {
                case true:
                    let filterdShopping = userDefaults.myShopping.filter { $0.productId == i.productId }
                    if let lastIndex = userDefaults.myShopping.lastIndex(where: {
                        $0.productId == filterdShopping[filterdShopping.startIndex].productId
                    }) {
                        userDefaults.myShopping.remove(at: lastIndex)
                    }
                case false:
                    if let lastIndex = userDefaults.myShopping.lastIndex(where: {
                        $0.productId == i.productId
                    }) {
                        userDefaults.myShopping.remove(at: lastIndex)
                    }
                }
            }
        }
        
        configureSelectButtonUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        shoppingImg.image = nil
        shoppingImg.contentMode = .scaleAspectFit
    }
}
