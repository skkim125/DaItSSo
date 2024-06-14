//
//  SortButton.swift
//  DaItSSo
//
//  Created by 김상규 on 6/14/24.
//

import UIKit

class SortButton: UIButton {
    
    init(sortType: SortType) {
        super.init(frame: .zero)
        
        setTitle(sortType.sortTitle, for: .normal)
        setTitleColor(UIColor.appBlack, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 15)
        
        backgroundColor = UIColor.appWhite
        
        layer.borderColor = UIColor.appDarkGray.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 16
        clipsToBounds = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
