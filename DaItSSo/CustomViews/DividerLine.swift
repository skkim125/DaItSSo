//
//  DividerLine.swift
//  DaItSSo
//
//  Created by 김상규 on 6/14/24.
//

import UIKit

class DividerLine: UIView {
    
    init(color: UIColor) {
        super.init(frame: .zero)
        
        backgroundColor = color
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
