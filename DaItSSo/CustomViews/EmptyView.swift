//
//  EmptyView.swift
//  DaItSSo
//
//  Created by 김상규 on 7/6/24.
//

import UIKit

class EmptyView: UIView {
    let emptyImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "empty")
        imgView.contentMode = .scaleAspectFit
        
        return imgView
    }()
    
    lazy var emptyLabel = {
        let label = UILabel()
        label.textColor = .appBlack
        label.font = .boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        backgroundColor = .appWhite
        configureHierarchy()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        addSubview(emptyImageView)
        addSubview(emptyLabel)
    }
    
    func configureEmptyLabel(text: String) {
        emptyLabel.text = text
    }
}

