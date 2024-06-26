//
//  ProfileImgCollectionViewCell.swift
//  DaItSSo
//
//  Created by 김상규 on 6/13/24.
//

import UIKit
import SnapKit

class ProfileImgCollectionViewCell: BaseCollectionViewCell {
    
    lazy var profileImgButton: ProfileButton = ProfileButton(profileImgType: .unSelected)
    lazy var profileImgView = UIImageView()
    
    override func configureHierarchy() {
        contentView.addSubview(profileImgButton)
        profileImgButton.addSubview(profileImgView)
    }
    
    override func configureLayout() {
        profileImgButton.snp.makeConstraints { make in
            make.size.equalTo(contentView)
        }
        
        profileImgView.snp.makeConstraints { make in
            make.edges.equalTo(profileImgButton)
        }
    }
    
    func configureCellUI(image: String, profileType: ProfileImgType) {
        profileImgView.image = UIImage(named: image)
        
        profileImgButton.isUserInteractionEnabled = false
        profileImgButton.layer.borderColor = profileType.borderColor.cgColor
        profileImgButton.layer.borderWidth = profileType.borderWidth
        profileImgButton.alpha = profileType.alpha
    }
}
