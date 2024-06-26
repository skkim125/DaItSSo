//
//  MyProfileTableViewCell.swift
//  DaItSSo
//
//  Created by 김상규 on 6/15/24.
//

import UIKit
import SnapKit

final class MyProfileTableViewCell: BaseTableViewCell {
    private let profileButton = ProfileButton(profileImgType: .isSelected)
    private let profileImgView = UIImageView()
    private lazy var labelStackView = {
        let sv = UIStackView(arrangedSubviews: [nicknameLabel, dateLabel])
        sv.axis = .vertical
        sv.spacing = 5
        
        return sv
    }()
    private let nicknameLabel = {
        let label = UILabel()
        label.textColor = .appBlack
        label.font = .systemFont(ofSize: 16, weight: .bold)
        
        return label
    }()
    private let dateLabel = {
        let label = UILabel()
        label.textColor = .appGray
        label.font = .systemFont(ofSize: 14)
        
        return label
    }()
    private let goUserDetailImageView = {
        let imgView = UIImageView(image: UIImage.nextButtonImg)
        imgView.contentMode = .scaleAspectFit
        imgView.tintColor = .appDarkGray
        
        return imgView
    }()
    
    private let userDefaults = UserDefaultsManager.shared
    var profileImg: String?
    
    override func configureHierarchy() {
        contentView.addSubview(profileButton)
        profileButton.addSubview(profileImgView)
        contentView.addSubview(labelStackView)
        contentView.addSubview(dateLabel)
        contentView.addSubview(goUserDetailImageView)
    }
    
    override func configureLayout() {
        profileButton.snp.makeConstraints { make in
            make.verticalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(15)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(20)
            make.width.equalTo(profileButton.snp.height)
        }
        
        profileImgView.snp.makeConstraints { make in
            make.size.edges.equalTo(profileButton)
        }
        
        labelStackView.snp.makeConstraints { make in
            make.leading.equalTo(profileButton.snp.trailing).offset(15)
            make.verticalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(30)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(labelStackView.snp.top).offset(10)
            make.horizontalEdges.equalTo(labelStackView.snp.horizontalEdges)
            make.height.equalTo(labelStackView.snp.height).multipliedBy(0.4)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom)
            make.height.equalTo(labelStackView.snp.height).multipliedBy(0.2)
            make.horizontalEdges.equalTo(labelStackView.snp.horizontalEdges)
        }
        
        goUserDetailImageView.snp.makeConstraints { make in
            make.leading.equalTo(labelStackView.snp.trailing).offset(20)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(20)
            make.centerY.equalTo(profileButton.snp.centerY)
            make.size.equalTo(25)
        }
    }
    
    func configureMyProfileCellUI(image: String, nickName: String, date: String) {
        profileImgView.image = UIImage(named: image)
        nicknameLabel.text = nickName
        dateLabel.text = date + " 가입"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        backgroundColor = .appWhite
    }
}
