//
//  MyShoppingCollectionVIewCell.swift
//  DaItSSo
//
//  Created by 김상규 on 7/6/24.
//

import UIKit

class myShoppingsCollectionViewCell: BaseCollectionViewCell {
    private let shoppingImg = {
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
    
    private let shoppingMallNameLabel = {
        let label = UILabel()
        label.textColor = .appGray
        label.font = .systemFont(ofSize: 13)
        
        return label
    }()
    
    private let shoppingTitleLabel = {
        let label = UILabel()
        label.textColor = .appBlack
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.numberOfLines = 0
        
        return label
    }()
    
    private let shoppingPriceLabel = {
        let label = UILabel()
        label.textColor = .appBlack
        label.font = .systemFont(ofSize: 16, weight: .heavy)
        
        return label
    }()
    
    private let selectProductButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.bordered()
        configuration.image = UIImage(systemName: "handbag.fill")
        configuration.image?.withTintColor(.appBlack)
        configuration.background.strokeColor = .appLightGray
        configuration.background.strokeWidth = 0.3
        button.configuration = configuration
        
        return button
    }()
    
    private let msr = MyShoppingRepository()
    private let userDefaults = UserDefaultsManager.shared
    var myShopping: MyShopping?
    var isAdd: Bool = true
    var myShoppingListView: MyShoppingListView?
    
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
    
    func configureCellUI(myShopping: MyShopping) {
        let loadImage = ImageManager.shared.loadImageToDocument(filename: myShopping.productId)
        self.shoppingImg.image = loadImage
        self.shoppingImg.contentMode = .scaleAspectFill
        shoppingMallNameLabel.text = myShopping.mallName
        shoppingTitleLabel.text = String.removeTag(title: myShopping.title)
        shoppingPriceLabel.text = String.formatInt(int: myShopping.lprice) + "원"
    }
    
    func configureSelectButton() {
        selectProductButton.configuration?.background.backgroundColor = .appWhite
        selectProductButton.configuration?.baseForegroundColor = .appBlack
        
        selectProductButton.addTarget(self, action: #selector(deleteProductButtonClicked), for: .touchUpInside)
    }
    
    @objc private func deleteProductButtonClicked() {
        
        if let i = myShopping {
            switch msr.loadMyShopping().isEmpty {
            case true:
                let filterdShopping = msr.loadMyShopping().filter { $0.productId == i.productId }
                if let lastIndex = msr.loadMyShopping().lastIndex(where: {
                    $0.productId == filterdShopping[filterdShopping.startIndex].productId
                }) {
                    ImageManager.shared.removeImageFromDocument(filename: i.productId)
                    msr.deleteMyShopping(msr.loadMyShopping()[lastIndex])
                }
            case false:
                if let lastIndex = msr.loadMyShopping().lastIndex(where: {
                    $0.productId == i.productId
                }) {
                    ImageManager.shared.removeImageFromDocument(filename: i.productId)
                    msr.deleteMyShopping(msr.loadMyShopping()[lastIndex])
                }
            }
            
            if let vc = myShoppingListView {
                vc.myShoppings = msr.loadMyShopping()
                if vc.myShoppings.isEmpty {
                    vc.setView()
                }
                vc.myShoppingsCollectionView.reloadData()
            }
        }
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        shoppingImg.image = nil
        shoppingImg.contentMode = .scaleAspectFit
    }
}
