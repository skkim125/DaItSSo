//
//  ProfileButton.swift
//  DaItSSo
//
//  Created by 김상규 on 6/13/24.
//

import UIKit


class ProfileButton: UIButton {
    
    init(_ mainImg: UIImageView) {
        super.init(frame: .zero)
        imageView?.contentMode = .scaleAspectFit
        layer.borderColor = UIColor.mainColor.cgColor
        layer.borderWidth = 3
        clipsToBounds = true
        addSubview(mainImg)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
