//
//  ProfileButton.swift
//  DaItSSo
//
//  Created by 김상규 on 6/13/24.
//

import UIKit


class ProfileButton: UIButton {
    
    init(profileImgType: ProfileImgType) {
        super.init(frame: .zero)
        imageView?.contentMode = .scaleAspectFit
        clipsToBounds = true
        layer.borderWidth = profileImgType.borderWidth
        layer.borderColor = profileImgType.borderColor
        imageView?.alpha = profileImgType.alpha
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = frame.size.width / 2
    }
}
