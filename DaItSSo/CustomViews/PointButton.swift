//
//  PointButton.swift
//  DaItSSo
//
//  Created by 김상규 on 6/13/24.
//

import UIKit

class PointButton: UIButton {
    init(title: String) {
        super.init(frame: .zero)
        
        setTitle(title, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 16, weight: .heavy)
        setTitleColor(UIColor.appWhite, for: .normal)
        backgroundColor = UIColor.mainColor
        layer.cornerRadius = 30
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
