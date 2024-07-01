//
//  PointButton.swift
//  DaItSSo
//
//  Created by 김상규 on 6/13/24.
//

import UIKit

final class PointButton: UIButton {
    init(title: String) {
        super.init(frame: .zero)
        var configuration = UIButton.Configuration.bordered()
        configuration.cornerStyle = .capsule
        configuration.title = title
        configuration.baseForegroundColor = .appWhite
        configuration.baseBackgroundColor = .appMainColor
        
        self.configuration = configuration
        
        titleLabel?.font = .systemFont(ofSize: 16, weight: .heavy)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
