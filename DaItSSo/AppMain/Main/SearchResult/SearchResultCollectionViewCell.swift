//
//  SearchResultCollectionViewCell.swift
//  DaItSSo
//
//  Created by 김상규 on 6/14/24.
//

import UIKit
import SnapKit

final class SearchResultCollectionViewCell: ProductCollectionViewCell {
    private let msr = MyShoppingRepository()
    var shopping: MyShopping?
    var isAdd: Bool = false
    var viewController: SearchResultViewController?
    
    func configureCellUI(myShopping: MyShopping) {
        guard let url = URL(string: myShopping.image) else { return }
        
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
        
        shoppingMallNameLabel.text = myShopping.mallName
        shoppingTitleLabel.text = String.removeTag(title: myShopping.title)
        shoppingPriceLabel.text = String.formatInt(int: myShopping.lprice) + "원"
    }
    
    func configureSelectButton() {
        selectProductButton.configuration?.background.backgroundColor = isAdd ? .appWhite : .appBlack.withAlphaComponent(0.3)
        selectProductButton.configuration?.baseForegroundColor = isAdd ? .appBlack : .appWhite
        
        selectProductButton.addTarget(self, action: #selector(selectProductButtonClicked), for: .touchUpInside)
    }
    
    @objc private func selectProductButtonClicked() {
        isAdd.toggle()
        
        if let i = shopping {
            if isAdd {
                let newShopping = MyShopping(productId: i.productId, title: i.title, image: i.image, mallName: i.mallName, lprice: i.lprice, link: i.link)
                msr.addMyShopping(newShopping)
                if let image = shoppingImg.image {
                    ImageManager.shared.saveImageToDocument(image: image, filename: i.productId)
                }
            } else {
                ImageManager.shared.removeImageFromDocument(filename: i.productId)
                msr.deleteMyShopping(msr.loadMyShopping().filter{ $0.productId == i.productId}.first!)
            }
        }
        
        configureSelectButton()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        shoppingImg.image = nil
        shoppingImg.contentMode = .scaleAspectFit
    }
}
