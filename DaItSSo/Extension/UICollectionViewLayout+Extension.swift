//
//  UICollectionViewLayout+Extension.swift
//  DaItSSo
//
//  Created by 김상규 on 6/26/24.
//

import UIKit


extension UICollectionViewLayout {
    static func searchResultCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        
        let sectionSpacing: CGFloat = 20
        let cellSpacing: CGFloat = 20
        let width = UIScreen.main.bounds.width-(sectionSpacing*2 + cellSpacing*1)
        
        layout.itemSize = CGSize(width: width/2, height: (width/2) * 1.8)
        layout.minimumLineSpacing = cellSpacing
        layout.minimumInteritemSpacing = cellSpacing
        layout.sectionInset = .init(top: 0, left: sectionSpacing, bottom: 0, right: sectionSpacing)
        layout.scrollDirection = .vertical
        
        return layout
    }
    
    static func selectProfileCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let cellSpacing: CGFloat = 10
        let sectionSpacing: CGFloat = 10
        let width = UIScreen.main.bounds.width-(sectionSpacing*2 + cellSpacing*3)
        
        layout.itemSize = CGSize(width: width/4, height: width/4)
        layout.minimumLineSpacing = cellSpacing
        layout.minimumInteritemSpacing = cellSpacing
        layout.sectionInset = .init(top: 0, left: sectionSpacing, bottom: 0, right: sectionSpacing)
        
        return layout
    }
}
