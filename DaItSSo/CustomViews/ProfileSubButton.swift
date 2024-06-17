//
//  ProfileSubButton.swift
//  DaItSSo
//
//  Created by 김상규 on 6/14/24.
//

import UIKit

class ProfileSubButton: UIButton {
    
    init() {
        super.init(frame: .zero)
        setImage(UIImage(systemName: "camera"), for: .normal)
        setImage(UIImage(systemName: "camera"), for: .highlighted)
        tintAdjustmentMode = .automatic
        contentMode = .center
        clipsToBounds = true
        tintColor = .appWhite
        backgroundColor = .appMainColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = frame.size.width / 2
    }
}
