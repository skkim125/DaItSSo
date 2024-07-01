//
//  SortButton.swift
//  DaItSSo
//
//  Created by 김상규 on 6/14/24.
//

import UIKit

final class SortButton: UIButton {
    
    init(sortType: SortType) {
        super.init(frame: .zero)
        
        var configuration = UIButton.Configuration.bordered()
        configuration.title = sortType.rawValue
        configuration.baseForegroundColor = .appDarkGray
        configuration.baseBackgroundColor = .appWhite
        configuration.background.strokeColor = .appDarkGray
        configuration.buttonSize = .small
        configuration.cornerStyle = .capsule
        
        self.configuration = configuration
        
        titleLabel?.font = .systemFont(ofSize: 14)
        tag = sortType.buttonTag
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
