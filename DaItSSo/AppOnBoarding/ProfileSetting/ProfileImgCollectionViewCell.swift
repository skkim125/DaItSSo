//
//  ProfileImgCollectionViewCell.swift
//  DaItSSo
//
//  Created by 김상규 on 6/13/24.
//

import UIKit
import SnapKit

class ProfileImgCollectionViewCell: UICollectionViewCell {
    
    lazy var profileImgButton: ProfileButton = {
        let button = ProfileButton(profileImgType: .unSelected)
        button.isUserInteractionEnabled = false
        return button
    }()
    
    lazy var profileImgView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureLayout()
        contentView.isUserInteractionEnabled = true
    }
    
    func configureHierarchy() {
        contentView.addSubview(profileImgButton)
        profileImgButton.addSubview(profileImgView)
    }
    
    func configureLayout() {
        profileImgButton.snp.makeConstraints { make in
            make.size.equalTo(contentView)
        }
        
        profileImgView.snp.makeConstraints { make in
            make.edges.equalTo(profileImgButton)
        }
    }
    
    func configureCellUI(image: String, profileType: ProfileImgType) {
        profileImgView.image = UIImage(named: image)
        
        profileImgButton.layer.borderColor = profileType.borderColor
        profileImgButton.layer.borderWidth = profileType.borderWidth
        profileImgButton.alpha = profileType.alpha
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
