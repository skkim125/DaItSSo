//
//  MyShoppingCollectionVIewCell.swift
//  DaItSSo
//
//  Created by 김상규 on 7/6/24.
//

import UIKit
import SnapKit

class MyShoppingsCollectionViewCell: ProductCollectionViewCell {
    
    private let msr = MyShoppingRepository()
    var myShopping: MyShopping?
    var isAdd: Bool = true
    var viewController: MyShoppingListView?
    
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
            ImageManager.shared.removeImageFromDocument(filename: i.productId)
            msr.deleteMyShopping(i)
            
            if let vc = viewController {
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
